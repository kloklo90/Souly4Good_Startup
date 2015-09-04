module ApplicationHelper

  def default_i_image(post)
    if post.image.present?
      return post.image
    else
      rand_n = rand(1..6)
      case rand_n
      when 1
        return 'crane-default.jpg'
      when 2
        return 'purple.jpg'
      when 3
        return 'pink.jpg'
      when 4
        return 'orange.jpg'
      when 5
        return 'green.jpg'
      when 6
        return 'blue.jpg'
      end
    end
  end

  def default_e_image(post)
    if post.external_image_url.present?

    end
  end

end
