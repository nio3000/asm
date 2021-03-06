#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')

# this file instantiates an Application instance & does the stuff
require 'optparse'
require 'yaml'
#require	'Asm/require_all.rb'

def start_bcpuvm
	# Setup the option parser.
	options = Hash.new
	optparse = cli_options(options)

	optparse.parse!

	if ARGV.empty?
		puts optparse
		exit false
	end

	# Configuration loaded to a constant (hash)
	# To access, config_settings['section']['key']
	config_settings = YAML.load_file('config.yaml')
	# Pass config file options to BCPU


	#didnt_have_breakfast = Asm::Application.new( )
	# Send output to file
end

def cli_options(options)
	OptionParser.new do |opts|
		opts.banner = "Usage: bcpuvm_cli [options] <asm-file>"

		options[:config] = nil
		opts.on('-c','--config FILE', 'YAML configuration file') do |f|
			options[:config] = f
		end

		options[:output] = nil
		opts.on('-o','--output FILE','Output file') do |f|
			options[:output] = f
		end

		opts.on('-h','--help','Display this screen.') do
			puts opts
			exit
		end
	end
end

start_bcpuvm

# encoding: UTF-8
