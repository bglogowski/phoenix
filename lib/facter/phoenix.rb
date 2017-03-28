if File.exist? '/opt/phoenix' and File.exist? '/opt/hbase'

  return_value = { 'installed' => true, 'version' => File.readlink('/opt/hbase').split('-')[-1] }

  hbase_version = File.readlink('/opt/hbase').split('-')[-1]
  phoenix_version = File.readlink('/opt/phoenix').split('-')[2]

  hbase_mm = hbase_version.split('.')[0..1].join('.')
    
  if File.readlink('/opt/phoenix').split('-')[-2] == hbase_mm

    return_value = { 'installed' => true, 'version' => phoenix_version }

    Facter.add(:phoenix) do
      setcode do
        return_value
      end
    end
  end

else
  Facter.add(:phoenix) do
    setcode do
      { 'installed' => false }
    end
  end
end
