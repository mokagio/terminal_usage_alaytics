# remember to run `rm -rf git_log; fc -R; fc -l -n -d -E -NUMBER > git_log`
# in ZSH to 
log_file = "git_log"

puts "Running analytics..."

commands = []

File.read(log_file).lines.each do |line|
	# strip the timestamp
  # no big checks, let's jsut rely on the fact the format is 
  #13.11.2013 00:05 command
  command_line = line[17,100000000].chomp # dirtiest way to get the substring

  while command_line[0] == " "
    command_line = command_line[1,100000000000]
  end

  found = false
  for command in commands
    if command[:command] == command_line
      found = true
      command[:count] += 1
      break
    end
  end
  if not found
    commands.push({ :command => command_line, :count => 1 })
  end
end

# compress commands that differs only for their only a string parameter
puts "Compressing commands..."

compressed_commands = []
for c in commands
  # puts "\nAnalysing command #{c}"

  if c[:command].split(' ').length > 1
    # puts "\tCommand #{c} matches. Starting search..."

    # first_argument = c[:command].split(' ')[1]
    # if first_argument[0] == "'" or first_argument[0] == '"'
      
    found = false
    for c_command in compressed_commands
      # puts "\t.....#{c_command[:command]} - #{c[:command].split(' ')[0]}"
      if c_command[:command] == c[:command].split(' ')[0]
        found = true
        c_command[:count] += 1
        break
      end
    end

    # puts "should push? #{found}"
    if not found
      hash = { :command => c[:command].split(' ')[0], :count => 1 }
      # puts "pushing #{hash} in compressed_commands"
      compressed_commands.push hash
    end

  else
    # puts "pushing #{c} in compressed_commands"
    compressed_commands.push c
  end
end

cnt = 0
for c in compressed_commands
  cnt += c[:count]
end

# puts "\n#{cnt}\n"
sorted_commands = compressed_commands.sort { |x,y| y[:count] <=> x[:count] }

puts "\nCommands Stats\n(skipping the ones used only once or twice, because of the three strokes and then automate rule)\n"
for command in sorted_commands
  if command[:count] > 2
    puts "#{command[:count]} - #{command[:command]}"
  end
end

puts "\nAnalysing top 10 commands looking for patterns"
puts "- looking for patters on the first command argument"
commands_with_first_argument = []
for command in sorted_commands[0,19]
  puts "\tlooking for patterns for command #{command[:command]}"
  first_arguments = []
  # 1. get all the matching commands in the history
  # 2. for each get the first argument
  # 2.1 loop in the first_arguments array, if not found add
  # 3. add the command + first argument pairs to the commanfs_with_frist_argument array
  for history_command in commands
    if history_command[:command].split(' ')[0] == command[:command]
      # puts history_command
      first_argument = history_command[:command].split(' ')[1]
      found = false
      for x in first_arguments
        if x[:argument] == first_argument
          found = true
          x[:count] += 1
          break
        end
      end
      hash = { :argument => first_argument, :count => 1 }
      first_arguments.push hash if not found
    end
  end
  puts "\tfound #{first_arguments.length} for #{command[:command]} (showing > 3 invocations)" 
  for argument in first_arguments.sort { |x,y| y[:count] <=> x[:count] }
    puts "\t\t#{argument[:count]} - #{command[:command]} #{argument[:argument]}" unless argument[:count] < 3
  end
  puts "\n"
end

puts "- looking for patterns on the entire command"
# same as above, but with the matching commands