require_relative 'config'

class CollisionChecker

  def CollisionChecker.collision?(first, second)
    first.zip(second).each do |f, s|
      return true if !Config.empty?(f) && !Config.empty?(s)
    end
    false
  end

end

