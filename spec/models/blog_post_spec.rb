require File.dirname(__FILE__) + '/../spec_helper'

describe BlogPost do
  before(:each) do
    @blog_post = BlogPost.new
  end

  it "should be valid" do
    @blog_post.should be_valid
  end
end
