#!/usr/bin/ruby
require 'rubygems'
require 'erb'
require 'ostruct'
require 'fileutils'
require 'yaml'
require 'inquirer'

DEFAULTS = File.exist?("defaults.yml") ? YAML::load_file("defaults.yml") : {}

def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def install
    puts "======================================================"
    puts "Symlinking files"
    puts "======================================================"
    files = get_files_to_process()
    puts "Processing:\n "
    files.each { |f| puts "\t#{f}" }
    puts
    puts

    file_options = %w{yes no always}
    always_overwrite = false
    files.each do |src_filename|
        f = src_filename.split("/", 2)[1] # Get rid of the "dotfiles/" prefix
        src_fullname = File.absolute_path(src_filename)

        puts %Q{mkdir -p "$HOME/.#{File.dirname(f)}"} if f =~ /\//
        system %Q{mkdir -p "$HOME/.#{File.dirname(f)}"} if f =~ /\//

        target_filename = File.join(ENV['HOME'], ".#{f.sub(/\.erb$/, '')}")
        puts "Processing: #{f} => #{target_filename}"
        if File.exist?(target_filename)
            if File.identical?(f, target_filename)
                puts "\tfiles are identical"
            else
                should_overwrite = Ask.confirm("File already exists: #{target_filename}. Overwrite it?", clear: true, response: false, default: false)

                should_overwrite = always_overwrite
                if !always_overwrite
                    response = Ask.list("File already exists: #{target_filename}. Overwrite it?", file_options)
                    always_overwrite = true if (file_options[response].to_sym == :always)
                    should_overwrite = always_overwrite or response == 1
                end

                if should_overwrite
                    puts "\tRemoving #{target_filename}"
                    FileUtils.rm(target_filename)
                else
                    puts "\tSkipping #{target_filename}"
                    next
                end
            end
        end

        process_file(src_fullname, target_filename)
    end
end

def get_files_to_process
    files = Dir.glob("dotfiles/**/*") - %w[bootstrap.rb defaults.yml README.md LICENSE oh-my-zsh .gitignore ]
    files.reject! { |f| File.directory?(f) }
    files
end

def is_erb?(f)
    f.end_with?(".erb")
end

def process_file(f, target_filename)
    # ERB - render the erb template to target location
    # Other - symlink

    if is_erb?(f)
        puts "\tGenerating #{target_filename}"
        erb_template = File.read(f)
        erb = ERB.new(erb_template)
        erb_rendered = ERB.new(erb_template).result(OpenStruct.new(DEFAULTS).instance_eval { binding })

        File.open(target_filename, 'w') do |new_file|
            new_file.write(erb_rendered)
        end
    else
        puts "\tSymlinking #{target_filename} => #{f}"
        FileUtils.ln_s(f, target_filename)
    end
end

install
