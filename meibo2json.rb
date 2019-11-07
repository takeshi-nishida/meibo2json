require 'csv'
require 'json'

$group_letters = [
  { name: "国際文化学研究科", letter: "c" },
  { name: "国際文化学部", letter: "c" },
  { name: "国際人間科学部", letter: "h" },
  { name: "理学部", letter: "s" },
  { name: "工学部", letter: "t" },
  { name: "経済学部", letter: "e" }
]


def get_id(number, groupname)
  suffix = $group_letters.find(){|g| groupname.include? g[:name] }
  return suffix ? number + suffix[:letter] : number
end

data = []

Dir.glob("data/*.csv") do |f|
  puts f
  rows = File.readlines(f, encoding: "Shift_JIS")

  # 最初の4行と最後の3行は不要なので捨てる
  rows[5..-4].each do |row|
    r = row.parse_csv
    s = {
      number: r[1].encode("UTF-8"),
      name: r[2].encode("UTF-8"),
      furigana: r[3].encode("UTF-8"),
      group: r[0].encode("UTF-8")
    }
    s[:id] = get_id(s[:number], s[:group])
    data.push(s)
  end
end

File.write("./users.json", JSON.pretty_generate(data))
