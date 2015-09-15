module ApplicationHelper

  def default_i_image(post)
    if post.image.present?
      return post.image
    else
      rand_n = rand(1..5)
      case rand_n
      when 60
        return 'crane-default.jpg'
      when 1
        return 'purple.jpg'
      when 2
        return 'pink.jpg'
      when 3
        return 'orange.jpg'
      when 4
        return 'green.jpg'
      when 5
        return 'blue.jpg'
      end
    end
  end

  def default_e_image(post)
    if post.external_image_url.present?
      return post.external_image_url
    else
      rand_n = rand(1..5)
      case rand_n
      when 60
        return 'crane-default.jpg'
      when 1
        return 'purple.jpg'
      when 2
        return 'pink.jpg'
      when 3
        return 'orange.jpg'
      when 4
        return 'green.jpg'
      when 5
        return 'blue.jpg'
      end
    end
  end

end
