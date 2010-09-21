require 'logical'

describe "Logical " do

  describe "Logical#to_ruby" do
    it "replaces '∨' with 'or'" do
      Logical.new("∨").to_ruby.should == "or"
    end

    it "replaces '∧' with 'and'" do
      Logical.new("∧").to_ruby.should == "and"
    end

    it "replaces '~' with '!'" do
      Logical.new("~").to_ruby.should == "!"
    end

    it "handles more complex statements" do
      statement = Logical.new("(a ∧ b)")
      statement.to_ruby.should == "(a and b)"
    end

    it "handles fairly complex statements" do
      statement = Logical.new("~((p ∧ q) ∧ (~p ∨ r)) ∧ ~(~(~(~s ∨ p) ∧ q) ∨ s)")
      statement.to_ruby.should == "!((p and q) and (!p or r)) and !(!(!(!s or p) and q) or s)"
    end
  end

  describe "Logical#variables" do
    it "extracts a single variable, form a single statement" do
      statement = Logical.new("a")
      statement.variables.should == ["a"]
    end

    it "excludes none variable characters" do
      statement = Logical.new("(a or b)")
      statement.variables.should == %W(a b)
      statement = Logical.new("(a ∧ b)")
      statement.variables.should == %W(a b)
    end

    it "returns only unique varialbes" do
      statment = Logical.new("a or b or a or a")
      statment.variables.should == %W(a b)
    end
  end

  describe "Logical#boolean_table" do
    it "variable count of 1" do
      Logical.boolean_table(1).should == [
        [true],
        [false]
      ]
    end

    it "returns 6 for 2" do
      Logical.boolean_table(2).should == [
        [true, true],
        [false,true],
        [true, false],
        [false,false]
      ]
    end

    it "returns x for 3" do
      Logical.boolean_table(3).should == [
        [true,true,true],
        [false,true,true],
        [true,false,true],
        [false,false,true],
        [true,true,false],
        [false,true,false],
        [true,false,false],
        [false,false,false]
      ]
    end
  end

  describe "logical#header" do
    it "display variables, and the header" do
      Logical.new("(a ∧ b)").header.should == ['a','b','(a ∧ b)']
    end
  end

  describe "Logical#header" do
    it "spits out the header" do
      Logical.new("(a ∧ b)").header.should == ['a','b','(a ∧ b)']
    end
  end

  describe "Logical#body" do
    it "test simple case" do
      Logical.new("(a ∧ b)").body.should == [
       [true,  true,  true],
       [false, true,  false],
       [true,  false, false],
       [false, false, false]
      ]
    end

    it "another simple test case" do
      Logical.new("(~p ∧ a)").body.should == [
        [true,  true,  false],
        [false, true,  true],
        [true,  false, false],
        [false, false, false]
      ]
    end

    it "test complex case" do
      Logical.new("~((p ∧ q) ∧ (~p ∨ r)) ∧ ~(~(~(~s ∨ p) ∧ q) ∨ s)").body.should ==[
        [true,  true,  true,  true, false],
        [false, true,  true,  true, false],
        [true,  false, true,  true, false],
        [false, false, true,  true, false],
        [true,  true,  false, true, false],
        [false, true,  false, true, false],
        [true,  false, false, true, false],
        [false, false, false, true, false],
        [true,  true,  true,  false, false],
        [false, true,  true,  false, false],
        [true,  false, true,  false, false],
        [false, false, true,  false, false],
        [true,  true,  false, false, false],
        [false, true,  false, false, false],
        [true,  false, false, false, false],
        [false, false, false, false, false]
      ]
    end
  end
end
