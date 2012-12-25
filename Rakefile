SRCDIR = "./src"

OUTDIR = "./lib/jsxmp"
directory OUTDIR

TESTDIR = "./spec"
directory TESTDIR

ALL_JS = "all.js"

task "default" => "dist"

desc "Initialize"
task "init" do
end

desc "Make distribution"
task "dist" => ["init"] do
end

desc "Watch coffee-script file."
task "watch" do
  sh "coffee -wcb -o #{OUTDIR} #{SRCDIR}"
end

desc "Clean distribution"
task "clean" do
end

# desc "Run Program"
# task "run" => "dist" do
#   sh "node #{OUTDIR}/#{ALL_JS}"
# end

desc "Run test"
task "test" do
  sh "jasmine-node --coffee #{TESTDIR}"
end
