# https://zenn.dev/itoo/articles/csv_to_json_of_ruby
require 'csv'
require 'json'

def str2num(val)
  cnv_f = val.to_f.to_s
  cnv_i = val.to_i.to_s
  if cnv_f == val
    return val.to_f
  elsif cnv_i == val
    return val.to_i
  end
  return val
end

if ARGV.size != 2
  puts "please name input & output files"
  exit
end

ifile = ARGV[0]
ofile = ARGV[1]

body = File.open(ifile).read

# csvオブジェクトを作成
csv = CSV.new(
  body,
  headers: true, # CSVファイルの一行目をヘッダとして扱う
  header_converters: :symbol, # ヘッダをシンボルに変換
  force_quotes: true # 文字をダブルクォーテーションで囲む
)

# csvを1行ずつハッシュに変換(この時点でヘッダがキーになっている)
rows = csv.to_a.map { |row| row.to_hash }
data = rows.map{|row| row.to_a.map{|k,v| [k, str2num(v)]}.to_h}

# jsonに変換してファイルに書き込み(作成)
File.open(ofile, "w") { |f| f.write data.to_json }
