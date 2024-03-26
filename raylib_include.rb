shared_lib_path = Gem::Specification.find_by_name('raylib-bindings').full_gem_path + '/lib/'

puts "shared_lib_path = #{shared_lib_path}"

########################################################################################
## Boiler plate stuff for getting path to .dll or shared library or whatever, depending
## on windows or a particular linux distro.
########################################################################################
case RUBY_PLATFORM
when /mswin|msys|mingw|cygwin/
  Raylib.load_lib(shared_lib_path + 'libraylib.dll', 
                  raygui_libpath: shared_lib_path + 'raygui.dll', 
                  physac_libpath: shared_lib_path + 'physac.dll')
when /darwin/
  arch = RUBY_PLATFORM.split('-')[0]
  Raylib.load_lib(shared_lib_path + "libraylib.#{arch}.dylib", 
                  raygui_libpath: shared_lib_path + "raygui.#{arch}.dylib",
                  physac_libpath: shared_lib_path + "physac.#{arch}.dylib")
when /linux/
  arch = RUBY_PLATFORM.split('-')[0]
  Raylib.load_lib(shared_lib_path + "libraylib.#{arch}.so",
                  raygui_libpath: shared_lib_path + "raygui.#{arch}.so",
                  physac_libpath: shared_lib_path + "physac.#{arch}.so")
else
  raise RuntimeError, "Unknown OS: #{RUBY_PLATFORM}"
end
########################################################################################
########################################################################################
########################################################################################

include Raylib


