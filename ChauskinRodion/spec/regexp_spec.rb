RSpec.describe Regexp do

  let (:truthy) {'truthy'}
  let (:falsey) {'falsey'}

  it 'should works for old functionality as designed' do
    conference = Regexp.new(/rubyconference|ruby|by/)

    expect(".by" =~ conference).to    eq  1
    expect("ruby" =~ conference).to   eq  0
    expect("java"  =~ conference).to  be_nil
  end

  it 'should be lucky' do
    lucky = Regexp.build(3, 7)
    expect("7"  =~ lucky).to  eq  truthy
    expect("13" =~ lucky).to  eq  falsey
    expect("3"  =~ lucky).to  eq  truthy
  end

  it 'should match month' do
    month = Regexp.build(1..12)

    expect("0" =~ month).to   eq  falsey
    expect("1" =~ month).to   eq  truthy
    expect("12" =~ month).to  eq  truthy
    expect("13" =~ month).to  eq  falsey
  end

  it 'should match days' do
    day = Regexp.build(1..31)

    expect("6" =~ day).to     eq  truthy
    expect("16" =~ day).to    eq  truthy
    expect("Tues" =~ day).to  eq  falsey
  end

  it 'should match years' do
    year = Regexp.build(98, 99, 2000..2005)

    expect("04" =~ year).to   eq  falsey
    expect("2004" =~ year).to eq  truthy
    expect("99" =~ year).to   eq  truthy
  end

  it 'should match number' do
    num = Regexp.build(0..1_000_000)

    expect("-1" =~ num).to    eq  falsey
  end

end
