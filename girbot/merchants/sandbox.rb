class Sandbox < Girbot::Step
  def action(options = {})
    options = {
      details: {
        auth: options[:details][:auth][1]
      }
    }
  end
end
