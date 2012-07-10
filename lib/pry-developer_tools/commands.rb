module PryDeveloperTools

  Commands = Pry::CommandSet.new do
    create_command "define-command", "Define a Pry command for this session." do
      banner <<-BANNER
        Usage: define-command "name", "my description" do
          p "I do something"
        end

        Define a Pry command.
      BANNER

      def process
        if args.empty?
          raise Pry::CommandError, "Provide an arg!"
        end

        prime_string = "command #{arg_string}\n"
        command_string = _pry_.r(target, prime_string)

        eval_string.replace <<-HERE
          _pry_.commands.instance_eval do
            #{command_string}
          end
        HERE
      end
    end

    create_command "reload-command", "Reload a Pry command." do
      banner <<-BANNER
        Usage: reload-command command
        Reload a Pry command.
      BANNER

      def process
        command = _pry_.commands.find_command(args.first)

        if command.nil?
          raise Pry::CommandError, 'No command found.'
        end

        source_code = command.block.source
        file, lineno = command.block.source_location

        set = Pry::CommandSet.new do
          eval(source_code, binding, file, lineno)
        end

        _pry_.commands.delete(command.name)
        _pry_.commands.import(set)
      end
    end

    create_command "edit-command", "Edit a Pry command." do
      banner <<-BANNER
        Usage: edit-command [options] command
        Edit a Pry command.
      BANNER

      def options(opt)
        opt.on :p, :patch, 'Perform a in-memory edit of a command'
      end

      def process
        if args.empty?
          raise Pry::CommandError, "No command given."
        end

        @command, @_target = find_command_and_target

        case
        when opts.present?(:patch)
          edit_temporarily
        else
          edit_permanently
        end
      end

      def find_command_and_target
        raw = args.first

        if raw.include?('#')
          command, method = raw.split('#', 2)
          command = _pry_.commands.find_command(command)
          target  = command.instance_method(method) rescue nil
        else
          command = _pry_.commands.find_command(raw)
          target  = command.block rescue nil
        end

        if command.nil?
          raise Pry::CommandError, "No command found."
        end

        if target.nil?
          raise Pry::CommandError, "Method '#{method}' could not be found."
        end

        [command, target]
      end

      def edit_permanently
        file, lineno = @_target.source_location
        invoke_editor(file, lineno, true)

        command_set = silence_warnings do
          eval File.read(file), TOPLEVEL_BINDING, file, 1
        end

        unless command_set.is_a?(Pry::CommandSet)
          raise Pry::CommandError,
                "Expected file '#{file}' to return a CommandSet"
        end

        _pry_.commands.delete(@command.name)
        _pry_.commands.import(command_set)
        set_file_and_dir_locals(file)
      end

      def edit_temporarily
        source_code = Pry::Method(@_target).source
        modified_code = nil

        temp_file do |f|
          f.write(source_code)
          f.flush

          invoke_editor(f.path, 1, true)
          modified_code = File.read(f.path)
        end

        command_set = Pry::CommandSet.new do
          silence_warnings do
            pry = Pry.new :input => StringIO.new(modified_code)
            pry.rep(binding)
          end
        end

        _pry_.commands.delete(@command.name)
        _pry_.commands.import(command_set)
      end
    end
  end

end

