# encoding: utf-8

require 'test_helper'

class CreatorTest < ActiveSupport::TestCase

  test '#create_or_update runs validations and returns false if invalid' do
    c = Plannings::Creator.new({})
    assert_difference 'Planning.count', 0 do
      assert !c.create_or_update
    end
    assert_nil c.plannings
    refute_empty c.errors
  end

  test '#create_or_update with no creates and no updates does nothing' do
    c = Plannings::Creator.new({ planning: { percent: 50 } })
    assert_difference 'Planning.count', 0 do
      assert c.create_or_update
    end
    assert_empty c.plannings
    assert_empty c.errors
  end

  test '#create_or_update creates new plannings' do
    params = { planning: { percent: 50, definitive: true },
               create: {
                 '1' => { employee_id: employees(:pascal).id,
                          work_item_id: work_items(:puzzletime).id,
                          date: '2000-01-03' },
                 '2' => { employee_id: employees(:pascal).id,
                          work_item_id: work_items(:puzzletime).id,
                          date: '2000-01-04' },
                 '3' => { employee_id: employees(:mark).id,
                          work_item_id: work_items(:puzzletime).id,
                          date: '2000-01-04' }
               }
    }
    c = Plannings::Creator.new(ActionController::Parameters.new(params))
    assert_difference 'Planning.count', 3 do
      assert c.create_or_update
    end

    assert_equal 3, c.plannings.length
    assert_empty c.errors

    assert_equal Date.new(2000, 1, 3), c.plannings.first.date
    assert_equal employees(:pascal).id, c.plannings.first.employee_id
    assert_equal work_items(:puzzletime).id, c.plannings.first.work_item_id

    assert_equal Date.new(2000, 1, 4), c.plannings.second.date
    assert_equal employees(:pascal).id, c.plannings.second.employee_id

    assert_equal Date.new(2000, 1, 4), c.plannings.third.date
    assert_equal employees(:mark).id, c.plannings.third.employee_id

    assert c.plannings.all? { |p| p.percent == 50 && p.definitive }
  end

  test '#create_or_update updates existing plannings and changes only present values' do
    p1 = Planning.create!({ employee_id: employees(:pascal).id,
                            work_item_id: work_items(:puzzletime).id,
                            date: '2000-01-03',
                            percent: 50,
                            definitive: true })
    p2 = Planning.create!({ employee_id: employees(:pascal).id,
                            work_item_id: work_items(:puzzletime).id,
                            date: '2000-01-04',
                            percent: 50,
                            definitive: true })
    p3 = Planning.create!({ employee_id: employees(:mark).id,
                            work_item_id: work_items(:puzzletime).id,
                            date: '2000-01-04',
                            percent: 50,
                            definitive: true })

    params = { planning: { percent: 25, definitive: false }, update: [p1.id, p3.id] }
    c = Plannings::Creator.new(ActionController::Parameters.new(params))
    assert_difference 'Planning.count', 0 do
      assert c.create_or_update
    end

    assert_equal 2, c.plannings.length
    assert_empty c.errors

    assert_equal Date.new(2000, 1, 3), p1.reload.date
    assert_equal employees(:pascal).id, p1.employee_id
    assert_equal 25, p1.percent
    assert !p1.definitive

    assert_equal Date.new(2000, 1, 4), p2.reload.date
    assert_equal employees(:pascal).id, p2.employee_id
    assert_equal 50, p2.percent
    assert p2.definitive

    assert_equal Date.new(2000, 1, 4), p3.reload.date
    assert_equal employees(:mark).id, p3.employee_id
    assert_equal 25, p3.percent
    assert !p3.definitive

    params = { planning: { percent: 30, definitive: '' }, update: [p1.id, p2.id] }
    c = Plannings::Creator.new(ActionController::Parameters.new(params))
    assert_difference 'Planning.count', 0 do
      assert c.create_or_update
    end

    assert_equal 2, c.plannings.length
    assert_empty c.errors

    assert_equal Date.new(2000, 1, 3), p1.reload.date
    assert_equal employees(:pascal).id, p1.employee_id
    assert_equal 30, p1.percent
    assert !p1.definitive

    assert_equal Date.new(2000, 1, 4), p2.reload.date
    assert_equal employees(:pascal).id, p2.employee_id
    assert_equal 30, p2.percent
    assert p2.definitive

    assert_equal Date.new(2000, 1, 4), p3.reload.date
    assert_equal employees(:mark).id, p3.employee_id
    assert_equal 25, p3.percent
    assert !p3.definitive

    params = { planning: { definitive: true }, update: [p3.id] }
    c = Plannings::Creator.new(ActionController::Parameters.new(params))
    assert_difference 'Planning.count', 0 do
      assert c.create_or_update
    end

    assert_equal 1, c.plannings.length
    assert_empty c.errors

    assert_equal Date.new(2000, 1, 3), p1.reload.date
    assert_equal employees(:pascal).id, p1.employee_id
    assert_equal 30, p1.percent
    assert !p1.definitive

    assert_equal Date.new(2000, 1, 4), p2.reload.date
    assert_equal employees(:pascal).id, p2.employee_id
    assert_equal 30, p2.percent
    assert p2.definitive

    assert_equal Date.new(2000, 1, 4), p3.reload.date
    assert_equal employees(:mark).id, p3.employee_id
    assert_equal 25, p3.percent
    assert p3.definitive
  end

  test '#create_or_update creates and updates plannings' do
    p1 = Planning.create!({ employee_id: employees(:mark).id,
                            work_item_id: work_items(:puzzletime).id,
                            date: '2000-01-04',
                            percent: 30,
                            definitive: false })
    params = { planning: { percent: 50, definitive: true },
               update: [p1.id],
               create: {
                 '1' => { employee_id: employees(:pascal).id,
                          work_item_id: work_items(:puzzletime).id,
                          date: '2000-01-03' },
               }
    }
    c = Plannings::Creator.new(ActionController::Parameters.new(params))
    assert_difference 'Planning.count', 1 do
      assert c.create_or_update
    end

    assert_equal 2, c.plannings.length
    assert_empty c.errors

    assert_equal Date.new(2000, 1, 4), p1.reload.date
    assert_equal employees(:mark).id, p1.employee_id
    assert_equal 50, p1.percent
    assert p1.definitive

    assert_equal Date.new(2000, 1, 3), Planning.last.date
    assert_equal employees(:pascal).id, Planning.last.employee_id
    assert_equal 50, Planning.last.percent
    assert Planning.last.definitive
  end

  test '#create_or_update returns false and sets errors on creation failure' do
    # create with employee_id/work_item_id/date that already exist
  end

  test '#create_or_update returns false and sets errors on update failure' do
    params = { planning: { percent: 25, definitive: false }, update: [-1] }
    c = Plannings::Creator.new(ActionController::Parameters.new(params))
    assert_difference 'Planning.count', 0 do
      assert !c.create_or_update
    end
    assert_nil c.plannings
    # assert c.errors.include?('Eintrag existiert nicht')
  end

  test '#form_valid? with no planning params returns false and sets errors' do
    [{}, { plannings: nil }, { plannings: {} }].each do |p|
      c = Plannings::Creator.new(p)
      assert !c.form_valid?, "Expected to be invalid for #{p}"
      assert c.errors.include?('Bitte füllen Sie das Formular aus'),
             "Expected to contain error for #{p}"
    end
  end

  test '#form_valid? for create with missing percent or definitive returns false and sets errors' do
    [{ percent: '', definitive: true, repeat_until: '2016 42' },
     { definitive: true, repeat_until: '2016 42' }].each do |p|
      c = Plannings::Creator.new({ planning: p, create: [{}] })
      assert !c.form_valid?, "Expected to be invalid for #{p}"
      assert c.errors.include?('Prozent müssen angegeben werden, um neue Planungen zu erstellen'),
             "Expected to contain error for #{p}"
    end

    [{ percent: 50, definitive: '', repeat_until: '2016 42' },
     { percent: 50, repeat_until: '2016 42' }].each do |p|
      c = Plannings::Creator.new({ planning: p, create: [{}] })
      assert !c.form_valid?, "Expected to be invalid for #{p}"
      assert c.errors.include?('Status muss angegeben werden, um neue Planungen zu erstellen'),
             "Expected to contain error for #{p}"
    end
  end

  test '#form_valid? for create with percent and definitive or repeat only returns true' do
    [{ percent: 50, definitive: true, repeat_until: '2016 42' },
     { percent: 50, definitive: false, repeat_until: '2016 42' },
     { repeat_until: '2016 42' }].each do |p|
      c = Plannings::Creator.new({ planning: p, create: [{}] })
      assert c.form_valid?, "Expected to be valid for #{p}"
      assert !c.errors.include?('Prozent müssen angegeben werden, um neue Planungen zu erstellen'),
             "Expected to not contain error for #{p}"
      assert !c.errors.include?('Status muss angegeben werden, um neue Planungen zu erstellen'),
             "Expected to not contain error for #{p}"
    end
  end

  test '#form_valid? with percent > 0 returns true' do
    ['1', '100'].each do |percent|
      c = Plannings::Creator.new({ planning: { percent: percent } })
      assert c.form_valid?, "Expected to be valid for #{percent}"
      assert !c.errors.include?('Prozent müssen grösser als 0 sein'),
             "Expected to not contain error for #{p}"
    end
  end

  test '#form_valid? with percent <= 0 returns false and sets errors' do
    ['0', '-1'].each do |percent|
      c = Plannings::Creator.new({ planning: { percent: percent } })
        assert !c.form_valid?, "Expected to be invalid for #{percent}"
        assert c.errors.include?('Prozent müssen grösser als 0 sein'),
               "Expected to contain error for #{p}"
    end
  end

  test '#form_valid? with valid repeat_until returns true' do
    ['201642', '2016 42'].each do |repeat_until|
      c = Plannings::Creator.new({ planning: { repeat_until: repeat_until } })
      assert c.form_valid?, "Expected to be valid for #{repeat_until}"
      assert !c.errors.include?('Wiederholungsdatum ist ungültig'),
             "Expected to not contain error for #{p}"
    end
  end

  test '#form_valid? with invalid repeat_until returns false and sets errors' do
    ['foo', '200099'].each do |repeat_until|
      c = Plannings::Creator.new({ planning: { repeat_until: repeat_until } })
      assert !c.form_valid?, "Expected to be invalid for #{repeat_until}"
      assert c.errors.include?('Wiederholungsdatum ist ungültig'),
             "Expected to contain error for #{p}"
    end
  end

  test '#repeat_only? returns true if :repeat_until is set and other values are not present' do
    c = Plannings::Creator.new({ planning: { repeat_until: '2016 42' }, create: {} })
    assert c.repeat_only?
  end

  test '#repeat_only? returns false if :repeat_until is not set or other values are present' do
    [{},
     { percent: 50, definitive: true },
     { percent: 50, definitive: false },
     { percent: 50, definitive: true, repeat_until: '' },
     { percent: 50, definitive: false, repeat_until: '' },
     { definitive: true, repeat_until: '2016 42' },
     { percent: '', definitive: false, repeat_until: '2016 42' },
     { percent: 50, repeat_until: '2016 42' },
     { percent: 50, definitive: '', repeat_until: '2016 42' }].each do |p|
      c = Plannings::Creator.new({ planning: p, create: {} })
      assert !c.repeat_only?, "Expected to be false for #{p}"
    end
  end

end