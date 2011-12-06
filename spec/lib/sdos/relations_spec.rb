require 'spec_helper'

module Sdos
  describe Relations do

    def path(filename)
       File.join(File.dirname(__FILE__), filename)
    end

    describe 'Relations.[]' do
      it 'should keep track of bidirectional relations' do
        input = StringIO.new <<-EOS
          emily: Ain't that the truth /cc @duncan
          duncan: hey @emily, can you pick up some of those cookies on your way home?
        EOS
        relations = Relations.new(TweetParser.new(input))

        relations['emily'].should == %w(duncan)
        relations['duncan'].should == %w(emily)
      end

      it 'should remove vertices contected with unidirectional relations' do
        input = StringIO.new <<-EOS
          christie: @emily, "Books are the best of things, well used; abused, among the worst." -- Emerson
          emily: Ain't that the truth /cc @duncan
          duncan: hey @emily, can you pick up some of those cookies on your way home?
        EOS
        relations = Relations.new(TweetParser.new(input))

        relations['emily'].should == %w(duncan)
        lambda do
          relations['christie'].should be_empty
        end.should raise_error(RGL::NoVertexError)
      end
      it 'should remove unidirectional edges' do
        input = StringIO.new <<-EOS
          a: @b @c
          b: @c
          c: @b @a
        EOS
        relations = Relations.new(TweetParser.new(input))

        relations['a'].should == %w(c)
        relations['b'].should == %w(c)
        relations['c'].should == %w(a b)
      end
      it 'shouldnt remove f as its bidirectionally contected with d' do
        input = StringIO.new <<-EOS
          a: @b @c @d
          b: @a @c @d
          c: @a @b @e
          d: @b @e @f
          e: @d @c
          f: @d
        EOS
        relations = Relations.new(TweetParser.new(input))

        relations['a'].should == %w(b c)
        relations['b'].should == %w(a c d)
        relations['c'].should == %w(a b e)
        relations['d'].should == %w(b e f)
        relations['e'].should == %w(c d)
        relations['f'].should == %w(d)
      end
    end

    describe 'Relations#friends' do
      it 'should return hash with friends' do
        input = StringIO.new <<-EOS
          a: @b @c
          b: @a
        EOS
        relations = Relations.new(TweetParser.new(input))

        relations.friends('a').should == { 1 => %w(b) }
        relations.friends('b').should == { 1 => %w(a) }
      end
      it 'should mention transitive friends' do
        input = StringIO.new <<-EOS
          a: @b @c
          b: @a
          c: @a
        EOS
        relations = Relations.new(TweetParser.new(input))

        relations.friends('a').should == { 1 => %w(b c) }
        relations.friends('b').should == { 1 => %w(a), 2 => %w(c) }
      end
      it 'should read input file' do
        File.open(path('sample_input.txt')) do |file|
          relations = Relations.new(TweetParser.new(file))

          relations.friends('alberta').should == { 1 => %w(bob christie), 2 => %w(duncan emily), 3 => %w(farid) }
          relations.friends('bob').should == { 1 => %w(alberta christie duncan), 2 => %w(emily farid) }
          relations.friends('christie').should == { 1 => %w(alberta bob emily), 2 => %w(duncan), 3 => %w(farid) }
          relations.friends('duncan').should == { 1 => %w(bob emily farid), 2 => %w(alberta christie) }
          relations.friends('emily').should == { 1 => %w(christie duncan), 2 => %w(alberta bob farid) }
          relations.friends('farid').should == { 1 => %w(duncan), 2 => %w(bob emily), 3 => %w(alberta christie) }
        end
      end
    end

  end
end
