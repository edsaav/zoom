require "email_guesser"

describe EmailGuesser do
  let(:e) { EmailGuesser.new }

  describe "domain" do
    context "given an empty string" do
      it "returns nil" do
        expect(e.domain("")).to eql(nil)
      end
    end

    context "given 'edward@gmail.com'" do
      it "returns 'gmail.com'" do
        expect(e.domain("edward@gmail.com")).to eql("gmail.com")
      end
    end

    context "given 'abcdefg'" do
      it "returns nil" do
        expect(e.domain("abcdefg")).to eql(nil)
      end
    end
  end

  describe "get_format" do
    context "given an empty string" do
      it "returns nil" do
        expect(e.get_format("")).to eql(nil)
      end
    end

    context "given 'edward@gmail.com'" do
      it "returns 'first'" do
        expect(e.get_format("edward@gmail.com")).to eql("first")
      end
    end

    context "given 'edward.saavedra@gmail.com'" do
      it "returns 'first.last'" do
        expect(e.get_format("edward.saavedra@gmail.com")).to eql("first.last")
      end
    end

    context "given 'e.saavedra@gmail.com'" do
      it "returns 'f.last'" do
        expect(e.get_format("e.saavedra@gmail.com")).to eql("f.last")
      end
    end

    context "given 'edward.s@gmail.com'" do
      it "returns 'first.l'" do
        expect(e.get_format("edward.s@gmail.com")).to eql("first.l")
      end
    end

    context "given 'jones@gmail.com'" do
      it "returns 'last'" do
        expect(e.get_format("jones@gmail.com")).to eql("last")
      end
    end

    context "given 'abc@gmail.com'" do
      it "returns 'unknown'" do
        expect(e.get_format("abc@gmail.com")).to eql("unknown")
      end
    end

    context "given 'ajones@gmail.com'" do
      it "returns 'flast'" do
        expect(e.get_format("ajones@gmail.com")).to eql("flast")
      end
    end

    context "given 'edwardjones@gmail.com'" do
      it "returns 'firstlast'" do
        expect(e.get_format("edwardjones@gmail.com")).to eql("firstlast")
      end
    end
  end

  describe "is_first_name?" do
    context "given an empty string" do
      it "returns false" do
        expect(e.is_first_name?("")).to eql(false)
      end
    end

    context "given 'edward'" do
      it "returns true" do
        expect(e.is_first_name?("edward")).to eql(true)
      end
    end

    context "given 'abc'" do
      it "returns false" do
        expect(e.is_first_name?("abc")).to eql(false)
      end
    end
  end

  describe "is_last_name?" do
    context "given an empty string" do
      it "returns false" do
        expect(e.is_last_name?("")).to eql(false)
      end
    end

    context "given 'edward'" do
      it "returns falst" do
        expect(e.is_last_name?("edward")).to eql(false)
      end
    end

    context "given 'jones'" do
      it "returns true" do
        expect(e.is_last_name?("jones")).to eql(true)
      end
    end
  end

  describe "is_first_last_combined" do
    context "given no input" do
      it "returns nil" do
        expect(e.is_first_last_combined?("")).to eql(nil)
      end
    end

    context "given 'edwardjones'" do
      it "returns true" do
        expect(e.is_first_last_combined?("edwardjones")).to eql(true)
      end
    end
  end

  describe "generate_email" do
    context "given 'Edward', 'Jones', 'bob.smith@gmail.com'" do
      it "returns 'edward.jones@gmail.com'" do
        expect(e.generate_email('Edward', 'Jones', 'bob.smith@gmail.com')).to eql('edward.jones@gmail.com')
      end
    end

    context "given 'Edward', 'Jones', 'bobsmith@gmail.com'" do
      it "returns 'edwardjones@gmail.com'" do
        expect(e.generate_email('Edward', 'Jones', 'bobsmith@gmail.com')).to eql('edwardjones@gmail.com')
      end
    end

    context "given 'Edward', 'Jones', 'bsmith@gmail.com'" do
      it "returns 'ejones@gmail.com'" do
        expect(e.generate_email('Edward', 'Jones', 'bsmith@gmail.com')).to eql('ejones@gmail.com')
      end
    end

    context "given 'Edward', 'Jones', 'bob@gmail.com'" do
      it "returns 'edward@gmail.com'" do
        expect(e.generate_email('Edward', 'Jones', 'bob@gmail.com')).to eql('edward@gmail.com')
      end
    end

    context "given 'Edward', 'Jones', 'smith@gmail.com'" do
      it "returns 'jones@gmail.com'" do
        expect(e.generate_email('Edward', 'Jones', 'smith@gmail.com')).to eql('jones@gmail.com')
      end
    end

    context "given 'Edward', 'Jones', 'b.smith@gmail.com'" do
      it "returns 'e.jones@gmail.com'" do
        expect(e.generate_email('Edward', 'Jones', 'b.smith@gmail.com')).to eql('e.jones@gmail.com')
      end
    end

    context "given 'Edward', 'Jones', 'bob.s@gmail.com'" do
      it "returns 'edward.j@gmail.com'" do
        expect(e.generate_email('Edward', 'Jones', 'bob.s@gmail.com')).to eql('edward.j@gmail.com')
      end
    end
  end

end
