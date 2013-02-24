module SearchHelper
end

class SearchResult < Object
  module Type
    USER = 1
  end

  def self.CreateUserResult(user)
    result = {
      :type => Type::USER,
      :user => user,
    }

    result
  end
end
