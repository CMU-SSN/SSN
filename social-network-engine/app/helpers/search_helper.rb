module SearchHelper
end

module SearchResult
  module Type
    POST = 1
    USER = 2
    ORGANIZATION = 3

    def self.ToName(type)
      if type == POST
        "Post"
      elsif type == USER
        "User"
      else
        "Organization"
      end
    end
  end

  def self.CreatePostResult(post)
    result = {
      :type => Type::POST,
      :post => post,
    }

    result
  end

  def self.CreateUserResult(user)
    result = {
      :type => Type::USER,
      :user => user,
    }

    result
  end

  # Outputs a link tag which is active if the current_type is the active_type
  def self.GetTypeLink(view, active_type, current_type, query)
    active_class = ''
    if active_type.to_i == current_type.to_i
      active_class = 'ui-btn-active'
    end

    print "Got: " + active_class.to_s
    type_link = view.search_path + "?type=" + current_type.to_s + "&q=" + query.to_s
    view.link_to Type::ToName(current_type), type_link, :class => active_class
  end
end
