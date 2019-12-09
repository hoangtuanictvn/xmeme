class VideoRenderWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default
  sidekiq_options retry: 2
  def perform(user_id, card_id)
    card = Card.find_by id: card_id
    return unless card.present?
    image = ImageRenderService.render(card, user_id)
    output = File.new("#{Rails.root}/public/videos/video_#{user_id}_#{card_id}.mp4", "wb")
    output.close
    movie = FFMPEG::Movie.new(card.music.container.url)
    # -ss 00:01:00 -t 120
    transcode_options = "-loop 1 -i #{Rails.root}/storage/#{image}.png -c:a aac -strict experimental -b:a 192k -pix_fmt yuv420p -vf fps=20 -movflags +faststart -shortest".strip.split(/\s+/)
    card.update_attributes render_status: :inprogress
    movie.transcode(output.path, {custom: transcode_options}){ |process|
      ActionCable.server.broadcast "render_status_user:#{user_id}", {id: card.id, progress: process*100, status: card.render_status}.to_json
    }
    card.update_attributes render_status: :success
    ActionCable.server.broadcast "render_status_user:#{user_id}", {id: card.id, progress: 100, status: card.render_status, url: "/videos/video_#{user_id}_#{card_id}.mp4"}.to_json
  end
end
