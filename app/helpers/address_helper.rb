module AddressHelper
  def communications resource
    com = []
    com << resource.email.to_s unless resource.email.blank?
    com << resource.telefon.to_s unless resource.telefon.blank?
    com << resource.fax.to_s unless resource.fax.blank?
    com.join(" | ")
  end

  def address_as_one_line resource
    resource.address.gsub("\r\n", ", ").gsub("\n", ", ").gsub("\r", ", ")
  end
end