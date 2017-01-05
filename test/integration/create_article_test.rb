require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
    
  def setup
    @user = User.create(username: "john", email: "john@example.com", password: "password")
  end
  
  test "create new article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: {title: "Article Title", description: "This is a new test article"}
    end
    assert_template 'articles/show'
    assert_match "Article Title", response.body
  end
  
  test "invalid article submision results in failure" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
        post_via_redirect articles_path, article: {title: "Valid", description: ""}
      end
      assert_template 'articles/new'
      assert_select 'h2.panel-title'
      assert_select 'div.panel-body'
    end
    
end