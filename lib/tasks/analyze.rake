
desc "Run brakeman"
task :brakeman do
  FileUtils.rm_f('brakeman-output.tabs')
  # some files seem to cause brakeman to hang. ignore them
  ignores = %w(nada)

  begin
    Timeout.timeout(300) do
      sh %W(brakeman -o brakeman-output.tabs
                     --skip-files #{ignores.join(',')}
                     -x ModelAttrAccessible
                     -q
                     --no-progress).join(' ')
    end
  rescue Timeout::Error => e
    puts "\nBrakeman took too long. Aborting."
  end
end

namespace :rubocop do
  desc 'Run .rubocop.yml and generate checkstyle report'
  task :report do
    # do not fail if we find issues
    sh %w(rubocop
          --require rubocop/formatter/checkstyle_formatter
          --format Rubocop::Formatter::CheckstyleFormatter
          --no-color
          --out rubocop-results.xml).join(' ') rescue nil
    true
  end
end