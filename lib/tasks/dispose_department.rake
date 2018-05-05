namespace :disposed_department do
  desc "不要な配属データを消してidを並び替える"

  # idを割り当て直す
  task reallocate: :environment do
    user_details = UserDetail.all
    sub_reps = SubRep.all

    puts "-----UserDetail-----"
    user_details.each do |ud|
      new_id = exchanger(ud.department_id)

      puts "#{ud.department_id}\t=>\t#{new_id}\n"

      ud.department_id = new_id
      ud.save
    end
    puts "-----SubRep-----"
    sub_reps.each do |sr|
      new_id = exchanger(sr.department_id)

      puts "#{sr.department_id}\t=>\t#{new_id}\n"

      sr.department_id = exchanger(sr.department_id)
      sr.save
    end
  end

  # 不要なデータを消す
  task delete: :environment do
    used_id = 20 # 20までは使う

    Department.where("id > #{used_id}").each do |d|
      d.destroy

      puts "id: #{d.id}, #{d} deleted."
    end
  end

  def exchanger(current_id)
    pat = {
      1 => 1,
      2 => 2,
      3 => 3,
      4 => 4,
      5 => 5,
      6 => 5,
      7 => 6,
      8 => 7,
      9 => 8,
      10 =>9,
      11 =>10,
      12 => 11,
      13 => 11,
      14 => 12,
      15 => 13,
      16 => 14,
      17 => 15,
      18 => 16,
      19 => 17,
      20 => 18,
      21 => 19,
      22 => 20,
      23 => 4,
      24 => 10,
      25 => 5,
      26 => 11,
      27 => 7,
      28 => 13
    }
    return pat[current_id]
  end
end
