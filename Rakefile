#! /usr/bin/rake
#
# Rake file for building binaries, libraries and unit tests. 
# Big Thanks to Pjotr Prins for showing me Rake

require 'rake/clean'

LIBS =  ['lib:libload', 'lib:core', 'lib:game', 'lib:stats', 'lib:options', 'lib:openGL', 
         'lib:openAL', 'lib:r', 'lib:jni', 'lib:gui', 'lib:sdl']
         
BIN =   ['app:fileloader', 'app:filesplitter', 'app:aligner', 'app:actor', 
         'app:single_map_probes', 'app:correlation', 'app:ostest', 'app:plang',
         'app:startJVM', 'app:httpreader', 'app:regression', 'app:httpserver',
         'app:gameserver', 'app:voynich', 'app:dnacode', 'app:testal', 'app:sdl']
TESTS = ['test:plang', 'tests:dnacode', 'test:fileloader', 'test:correlation', 
         'test:httpreader' ]

def bd;return "build";end

def windows?;return RUBY_PLATFORM =~ /(:?mswin|mingw)/;end

comp_args  = "-O"
link_args = ""

def execext
  if windows? then
    return "exe"
  else
    return "bin"
  end
end

CLEAN.include("#{bd}*.*")
CLEAN.include("#{bd}")
CLEAN.include("*.#{execext}")
CLEAN.include("*.save")

core_files    = Dir.glob("./src/core/**/*.d").join(' ')
io_files      = Dir.glob("./src/io/**/*.d").join(' ')
inter_files   = Dir.glob("./src/interpreters/*.d").join(' ')
libload_files = Dir.glob("./src/libload/*.d").join(' ')
game_files    = Dir.glob("./src/game/**/*.d").join(' ')
sfx_files     = Dir.glob("./src/sfx/**/*.d").join(' ')
web_files     = Dir.glob("./src/web/**/*.d").join(' ')
genetic_files = Dir.glob("./src/genetics/*.d").join(' ')
plugin_gui    = Dir.glob("./src/gui/**/*.d").join(' ')
plugin_stats  = Dir.glob("./src/plugins/regression/*.d").join(' ')
plugin_opts   = Dir.glob("./src/plugins/optionsparser/*.d").join(' ')
deps_opengl   = Dir.glob("./deps/gl/*.d").join(' ')
deps_openal   = Dir.glob("./deps/openal/*.d").join(' ')
deps_r        = Dir.glob("./deps/r/*.d").join(' ')
deps_jni      = Dir.glob("./deps/jni/*.d").join(' ')
deps_sdl      = Dir.glob("./deps/sdl/*.d").join(' ')

directory bd

def libext
  if windows? then
    return "lib"
  else
    return "a"
  end
end

# ---- Standard Libs ----
namespace :lib do
  desc "Build all libraries"
  task :all => LIBS
  
  desc "The library with core functionality"
  task "core" do
    sh "dmd -lib -c #{core_files} -of#{bd}/core.#{libext}"
  end

  desc "The library with io functionality"
  task "io" do
    sh "dmd -lib -c #{core_files} #{io_files} -of#{bd}/io.#{libext}"
  end
  
  desc "The library with sfx functionality"
  task "sfx" => ['lib:openAL'] do
    sh "dmd -lib -c #{sfx_files} -of#{bd}/sfx.#{libext} -Isrc/ -Ideps/"
  end
  
  desc "The library providing interpreters"
  task "inter" do
    sh "dmd -lib -c #{inter_files} -of#{bd}/interpreters.#{libext}"
  end
  
  desc "The library with libload functionality"
  task "libload" do
    if ! windows? then
      link_args += " -L-ldl"
    end
    sh "dmd -lib -c #{libload_files} -of#{bd}/libload.#{libext}"
  end
  
  desc "Library with game functionality (A* search)"
  task "game" do
    sh "dmd -lib -c #{game_files} -of#{bd}/game.#{libext} -Isrc/ -Ideps/"
  end

  desc "Library with http/web functionality"
  task "web" do
    sh "dmd -lib -c #{web_files} -of#{bd}/web.#{libext} -Isrc/"
  end
  
  desc "Library with genetics functionality"
  task "genetics" do
    sh "dmd -lib -c #{genetic_files} -of#{bd}/genetics.#{libext} -Isrc/"
  end
  
  desc "Libary with basic statistics functions"
  task "stats" do
    sh "dmd -lib -c #{plugin_stats} -of#{bd}/stats.#{libext} -Isrc/ -Ideps/"
  end
  
  desc "Libary with basic option parsing functions"
  task "options" do
    sh "dmd -lib -c #{plugin_opts} -of#{bd}/options.#{libext} -Isrc/ -Ideps/"
  end

  desc "Bindings for openGL"
  task "openGL" => :libload do
    sh "dmd -lib -c #{deps_opengl} #{bd}/libload.#{libext} -of#{bd}/openGL.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Bindings for openAL"
  task "openAL" => :libload do
    sh "dmd -lib -c #{deps_openal} #{bd}/libload.#{libext} -of#{bd}/openAL.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Bindings for R"
  task "r" => :libload do
    sh "dmd -lib -c #{deps_r} #{bd}/libload.#{libext} -of#{bd}/r.#{libext} -Ideps/ -Isrc/"
  end

  desc "Bindings for JNI"
  task "jni" => :libload do
    sh "dmd -lib -c #{deps_jni} #{bd}/libload.#{libext} -of#{bd}/jni.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Bindings for SDL"
  task "sdl" => :libload do
    sh "dmd -lib -c #{deps_sdl} #{bd}/libload.#{libext} -of#{bd}/sdl.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "SDL GUI libary"
  task "gui" do
    sh "dmd -lib -c #{plugin_gui} -of#{bd}/gui.#{libext} -Ideps/ -Isrc/"
  end
end
# ---- Applications ----

namespace :app do
  desc "Build all applications and libraries"
  task :all => BIN
  
  desc "Fileloader application"
  task "fileloader" do
    sh "dmd src/main/fileloader.d #{core_files} #{io_files} -od#{bd} -offileloader.#{execext}"
  end

  desc "Large file splitter"
  task "filesplitter" do
    sh "dmd src/main/filesplitter.d #{core_files} #{io_files} -od#{bd} -offilesplit.#{execext}"
  end

  desc "DNA sequence alignment using blastn"
  task "aligner" do
    sh "dmd src/main/aligner.d #{core_files} #{io_files} -od#{bd} -ofaligner.#{execext}"
  end
  
  desc "Actor example from D"
  task "actor" do
    sh "dmd src/main/actor.d #{core_files} -od#{bd} -ofactor.#{execext}"
  end

  desc "os test"
  task "ostest" do
    sh "dmd src/main/ostest.d #{core_files} #{io_files} -od#{bd} -ofostest.#{execext}"
  end
  
  desc "Extract probes mapping to a single genome location"
  task "single_map_probes" do
    sh "dmd src/main/single_map_probes.d #{core_files} #{io_files} -od#{bd} -ofmap_probes.#{execext}"
  end
  
  desc "Correlation test using the Statistics library"
  task "correlation" do
    sh "dmd src/main/correlation.d #{core_files} #{libload_files} #{io_files} #{plugin_stats} #{deps_r} -od#{bd} -ofcorrelation.#{execext} -L-ldl"
  end
  
  desc "P'' language interpreter (see: http://en.wikipedia.org/wiki/P'')"
  task "plang" do
    sh "dmd src/main/plang.d #{core_files} #{inter_files} -od#{bd} -ofplang.#{execext}"
  end

  desc "Start the JVM"
  task "startJVM" do
    sh "dmd src/main/startJVM.d #{core_files} #{libload_files} #{deps_jni} -od#{bd} -ofstartJVM.#{execext} -L-ldl"
  end
  
  desc "Basic HTTP response slurper"
  task "httpreader" do
    sh "dmd src/main/httpreader.d #{core_files} #{web_files} -od#{bd} -ofhttpreader.#{execext}"
  end
  
  desc "Multiple lineair regression"
  task "regression" do
    sh "dmd src/main/regression.d #{core_files} #{libload_files} #{plugin_stats} #{deps_r} -od#{bd} -ofregression.#{execext} -L-ldl"
  end
  
  desc "HTPPserver supporting D as CGI"
  task "httpserver" do
    sh "dmd src/main/httpserver.d #{core_files} #{web_files} -od#{bd} -ofhttpserver.#{execext}"
  end
  
  desc "Server for a multiplayer network mud"
  task "gameserver" do
    sh "dmd src/main/server.d #{core_files} #{libload_files} #{web_files} #{game_files} #{plugin_gui} #{sfx_files} #{deps_sdl} #{deps_opengl} #{deps_openal} -od#{bd} -ofserver.#{execext} -L-ldl"
  end

  desc "Decode voynich"
  task "voynich" => 'lib:core' do
    sh "dmd src/main/voynich.d #{core_files} -od#{bd} -ofvoynich.#{execext}"
  end
  
  desc "Scan for proteins in DNA code"
  task "dnacode" do
    sh "dmd src/main/dnacode.d #{core_files} #{genetic_files} -od#{bd} -ofdnacode.#{execext}"
  end

  desc "Test openAL bindings"
  task "testal" do
    sh "dmd src/main/testal.d #{core_files} #{libload_files} #{deps_openal} -od#{bd} -oftestal.#{execext} -L-ldl"
  end

  desc "SDL engine"
  task "sdl" do
    sh "dmd -g src/main/sdlengine.d #{core_files} #{libload_files} #{web_files} #{game_files} #{plugin_gui} #{sfx_files} #{deps_sdl} #{deps_opengl} #{deps_openal} -od#{bd} -ofsdltest.#{execext} -L-ldl"
  end
end

# ---- Default task ----

desc "Default is to build all applications"
task :default => 'app:all' do
  print "Build OK\n"
end

desc "Run the unit test"
task :unittest do
  sh "dmd -unittest src/main/empty.d #{core_files} #{libload_files} #{io_files} #{inter_files} #{game_files} #{web_files} #{sfx_files} #{genetic_files} #{plugin_gui} #{deps_sdl} #{deps_opengl} #{deps_openal}"
end

desc "Build all game-executables"
task :game => ['app:gameserver', 'app:sdltest' ] do
  print "Game OK\n"
end

# ---- Unit tests ----

namespace :test do
  desc "Run all tests"
  task :all => TESTS do
    print "All tests OK\n"
  end
  
  desc "Test Plang"
  task :plang => [ 'app:plang' ] do 
    print "Testing p'' language interpreter\n"
    sh "./plang.#{execext}"
    sh "./plang.#{execext} 'Rl(l)' 010"
  end
  desc "Test DNAcode"
  task :dnacode => [ 'app:dnacode' ] do 
    print "Testing DNA translation\n"
    sh "./dnacode.#{execext}"
    sh "./dnacode.#{execext} AAAATGATTGAGTAGGATGGATTCTATATCTCTACTCATTTTGTCGCTT"
  end
  
  desc "Test Fileloader"
  task :fileloader => [ 'app:fileloader' ] do 
    print "Testing fileloader\n"
    sh "./fileloader.#{execext}"
    #sh "./fileloader data/csv/test.csv"
    #sh "./fileloader data/csv/test.csv 2mb"
    #sh "./fileloader data/csv/test.csv 2mb 1 23"
  end
  
  desc "Test Regression"
  task :regression => [ 'app:regression' ] do 
    print "Testing regression\n"
    sh "./regression.#{execext}"
  end
  
  desc "Test Correlation"
  task :correlation => [ 'app:correlation' ] do 
    print "Testing correlation\n"
    sh "./correlation.#{execext}"
    #sh "./correlation data/csv/test.csv 2mb"
  end
  
  desc "Test HTTPreader"
  task :httpreader => [ 'app:httpreader' ] do 
    print "Testing httpreader\n"
    sh "./httpreader.#{execext}"
    sh "./httpreader.#{execext} www.dannyarends.nl 80 /" 
  end
end
