require 'spec_helper'

describe MadLib do
  it 'should store text' do
    mad_lib = FactoryGirl.build :mad_lib
    mad_lib.text.should be
  end

  it 'should store text resiliently' do
    sentence = Faker::Lorem.sentence
    mad_lib = MadLib.new :text => sentence
    mad_lib.text.should eql sentence
  end

  it 'should have solutions' do
    MadLib.new.solutions.should be
  end

  it 'should have hashes' do
    MadLib.new.hashes.should be_a Hash
  end

  it 'should resolve to a solution' do
    sentence = 'I {verb, past-tense} the {noun}. It was {adjective}.'
    MadLib.new(:text => sentence).solutions.create.resolve.should be_a String
  end

  it 'should resolve a good solution' do
    sentence = 'I {verb, past-tense} the {noun}. It was {adjective}.'
    solution = MadLib.new(:text => sentence).solutions.create
    solution.fill_field 'Verb, past-tense (1):', :with => 'walked'
    solution.fill_field 'Noun (1):', :with => 'dog'
    solution.fill_field 'Adjective (1):', :with => 'exciting'
    solution.resolve.should eql('I walked the dog. It was exciting.')
  end

  it 'should generate statistics' do
    sentence = 'I {verb, past-tense} the {noun}. It was {adjective}.'
    solution = MadLib.new(:text => sentence).solutions.create
    solution.fill_field 'Verb, past-tense (1):', :with => 'walked'
    solution.fill_field 'Noun (1):', :with => 'dog'
    solution.fill_field 'Adjective (1):', :with => 'exciting'
    MadLibField.where(:name => 'Verb').count.should eql 1
    MadLibField.where(:name => 'Noun').count.should eql 1
    MadLibField.where(:name => 'Adjective').count.should eql 1
    MadLibTerm.where(:name => 'walked').count.should eql 1
    MadLibTerm.where(:name => 'dog').count.should eql 1
    MadLibTerm.where(:name => 'exciting').count.should eql 1
  end

  it 'should resolve a good solution for a complex mad lib' do
    sentence = "Programming is a craft. At its simplest, it comes down to getting a {noun} to do what you want it to do (or what your {noun} wants it to do). As a {job}, you are part listener, part advisor, part interpreter, and part {job}. You try to {verb} {adjective} requirements and find a way of expressing them so that a mere {noun} can do them justice. You try to {verb} your work so that others can {verb} it, and you try to engineer your {noun} so that others can {verb} on it. What's more, you try to do all this against the relentless {verb, ending in -ing} of the {noun}. You work {adjective} miracles every day."
    solution = MadLib.new(:text => sentence).solutions.create
    solution.fill_field 'Noun (1):', :with => 'keyboard cat'
    solution.fill_field 'Noun (2):', :with => 'dog'
    solution.fill_field 'Noun (3):', :with => 'post-it'
    solution.fill_field 'Noun (4):', :with => 'coke'
    solution.fill_field 'Noun (5):', :with => 'cup'
    solution.fill_field 'Job (1):', :with => 'airline pilot'
    solution.fill_field 'Job (2):', :with => 'clown'
    solution.fill_field 'Verb (1):', :with => 'sit'
    solution.fill_field 'Verb (2):', :with => 'jump'
    solution.fill_field 'Verb (3):', :with => 'sing'
    solution.fill_field 'Verb (4):', :with => 'dance'
    solution.fill_field 'Adjective (1):', :with => 'shiny'
    solution.fill_field 'Adjective (2):', :with => 'bright'
    solution.fill_field 'Verb, ending in -ing (1):', :with => 'dancing'
    solution.resolve.should eql("Programming is a craft. At its simplest, it comes down to getting a keyboard cat to do what you want it to do (or what your dog wants it to do). As a airline pilot, you are part listener, part advisor, part interpreter, and part clown. You try to sit shiny requirements and find a way of expressing them so that a mere post-it can do them justice. You try to jump your work so that others can sing it, and you try to engineer your coke so that others can dance on it. What's more, you try to do all this against the relentless dancing of the cup. You work bright miracles every day.")
  end

  it 'should allow the same field to be filled twice' do
    sentence = 'I {verb, past-tense} the {noun}. It was {adjective}.'
    solution = MadLib.new(:text => sentence).solutions.create
    solution.fill_field 'Verb, past-tense (1):', :with => 'strolled'
    solution.fill_field 'Noun (1):', :with => 'dog'
    solution.fill_field 'Adjective (1):', :with => 'exciting'
    solution.fill_field 'Verb, past-tense (1):', :with => 'walked'
    solution.resolve.should eql('I walked the dog. It was exciting.')
  end

  it 'should resolve a random mad lib' do
    word = Faker::Lorem.word
    mad_lib = FactoryGirl.build :mad_lib
    parts = mad_lib.text.split(' ')
    mad_lib.text = mad_lib.text.split(' ').insert(3, '{noun}').join(' ')
    solution = mad_lib.solutions.create
    solution.fill_field 'Noun (1):', :with => word
    solution.resolve.should eql(mad_lib.text.sub(/{noun}/, word))
  end

end
