# Script to get insights on the commands used in the terminal

def sputs(message)
  puts message unless true
end

def parse_zsh_histfile_line(line)
  # line format
  # : 1385080058:0;command --option argument
  return nil if line[0] != ":"

  {
    :timestamp => line.split(":")[1][1..-1], 
    :full_command => line[(line.index(";") + 1)..-1].chomp.lstrip
  }
end

if not ARGV[0]
  sputs "No path to zsh histroy file given.\nTerminating."
  exit
end

if not File.exists? ARGV[0]
  sputs "History file at path #{ARGV[0]} does not exist.\nTerminating."
  exit
end

sputs "Running analytics..."

commands = []

File.read(ARGV[0]).lines.each do |line|
  parsed_line = parse_zsh_histfile_line line

  if parsed_line
    command_line = parsed_line[:full_command]

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
end

# compress commands that differs only for their only a string parameter
sputs "Compressing commands..."

commands_by_first_word = []
for c in commands
  # puts "\nAnalysing command #{c}"

  if c[:command].split(' ').length > 1
    # sputs "\tCommand #{c} matches. Starting search..."

    # first_argument = c[:command].split(' ')[1]
    # if first_argument[0] == "'" or first_argument[0] == '"'
      
    found = false
    for already_found in commands_by_first_word
      # sputs "\t.....#{already_found[:command]} - #{c[:command].split(' ')[0]}"
      if already_found[:command] == c[:command].split(' ')[0]
        found = true
        already_found[:count] += c[:count]
        break
      end
    end

    # sputs "should push? #{found}"
    if not found
      hash = { :command => c[:command].split(' ')[0], :count => c[:count] }
      # sputs "pushing #{hash} in commands_by_first_word"
      commands_by_first_word.push hash
    end

  else
    # sputs "pushing #{c} in commands_by_first_word"
    commands_by_first_word.push c
  end
end

cnt = 0
for c in commands_by_first_word
  cnt += c[:count]
end

# sputs "\n#{cnt}\n"
sorted_commands = commands_by_first_word.sort { |x,y| y[:count] <=> x[:count] }

sputs "\nCommands Stats\n(skipping the ones used only once or twice, because of the three strokes and then automate rule)\n"
for command in sorted_commands
  if command[:count] > 2
    sputs "#{command[:count]} - #{command[:command]}"
  end
end

sputs "\nAnalysing top 10 commands looking for patterns"
sputs "- looking for patters on the first command argument"
commands_with_first_argument = []
for command in sorted_commands[0,19]
  sputs "\tlooking for patterns for command #{command[:command]}"
  first_arguments = []
  # 1. get all the matching commands in the history
  # 2. for each get the first argument
  # 2.1 loop in the first_arguments array, if not found add
  # 3. add the command + first argument pairs to the commanfs_with_frist_argument array
  for history_command in commands
    if history_command[:command].split(' ')[0] == command[:command]
      # sputs history_command
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
  sputs "\tfound #{first_arguments.length} for #{command[:command]} (showing > 3 invocations)" 
  for argument in first_arguments.sort { |x,y| y[:count] <=> x[:count] }
    sputs "\t\t#{argument[:count]} - #{command[:command]} #{argument[:argument]}" unless argument[:count] < 3
  end
  sputs "\n"
end

sputs "- looking for patterns on the entire command"
# same as above, but with the matching commands