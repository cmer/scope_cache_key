shared_examples_for "an adapter with scope_cache_key" do
  before(:all) do
    @article = create_article
    create_comment(Article.first, 100)
  end

  after(:all) do
    Article.destroy_all
    Comment.destroy_all
  end

  context "#cache_key" do
    context "model" do
      it "returns the correct value" do
        scope = Comment
        scope.cache_key.should == "comments/#{md5(scope)}"
      end
    end

    context "after a record is updated" do
      it "returns the correct value" do
        old_key = Comment.cache_key
        Comment.first.update_attributes(updated_at: Time.now + 2.seconds)
        Comment.cache_key.should_not == old_key
      end
    end

    context "after a record is deleted" do
      it "returns the correct value" do
        old_key = Comment.cache_key
        Comment.first.destroy
        Comment.cache_key.should_not == old_key
      end
    end

    context "scope returns an empty dataset" do
      it "returns the correct value" do
        Comment.where("1=2").cache_key.should == "comments/empty"
      end
    end

    context "when order is specified" do
      it "returns the correct value" do
        scope = Comment.reorder(:id)
        scope.cache_key.should == "comments/#{md5(scope)}"
      end
    end

    context "when joined with another table" do
      it "returns the correct value" do
        Comment.joins(:article).cache_key.should_not == "comments/empty"
      end
    end

    context "when included with another table" do
      it "returns the correct value" do
        Comment.includes(:article).cache_key.should_not == "comments/empty"
      end
    end

    context "when offset is specified" do
      it "returns the correct value" do
        Comment.order(:id).offset(1).limit(1).cache_key.should_not == "comments/empty"
      end
    end
  end


  context "Fragment Cache Key" do
    let(:controller) { ApplicationController.new }

    it "returns the correct value when passed a simple model" do
      controller.fragment_cache_key(Comment).should end_with(Comment.cache_key)
    end

    it "returns the correct value when passed a version and model" do
      controller.fragment_cache_key(['v1', Comment]).should end_with("v1/#{Comment.cache_key}")
    end

    it "returns the correct value when passed complex arguments" do
      objects = ['v1', Comment, Comment.where('1=2')]
      controller.fragment_cache_key(objects).should end_with(
        "v1/#{Comment.cache_key}/comments/empty")
    end
  end
end