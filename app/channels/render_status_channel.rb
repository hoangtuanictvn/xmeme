class RenderStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "render_status_user:#{current_user.id}"
    #stream_for current_user
  end

  def unsubscribed
    
  end
end
