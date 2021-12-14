require 'fileutils'

sample_dir = './sample_solution'

day = ARGV[0]

target_dir = "./day_#{day.rjust(2, '0')}"

FileUtils.copy_entry(sample_dir, target_dir)
