class EntityAttribute < ActiveRecord::Base
  connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")

  set_table_name "a.entity_attribs"
  set_primary_key :eno
  set_date_columns :entrydate, :qadate, :confid_until, :lastupdate
  def self.state
    with_scope(:find => { :conditions => "attribute = 'State'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.commodity
    with_scope(:find => { :conditions => "attribute = 'Commodity'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.project_type
    with_scope(:find => { :conditions => "attribute = 'Project type'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.principal_company
    with_scope(:find => { :conditions => "attribute = 'Principal company'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.capacity
    with_scope(:find => { :conditions => "attribute = 'Capacity'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.status
    with_scope(:find => { :conditions => "attribute = 'Status'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.comments
    with_scope(:find => { :conditions => "attribute = 'Comments'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.employment
    with_scope(:find => { :conditions => "attribute = 'Employment'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.location
    with_scope(:find => { :conditions => "attribute = 'Location'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.reference
    with_scope(:find => { :conditions => "attribute = 'Reference'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.capital_expenditure
    with_scope(:find => { :conditions => "attribute = 'Capital expenditure'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.technology
    with_scope(:find => { :conditions => "attribute = 'Technology'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  def self.commencement
    with_scope(:find => { :conditions => "attribute = 'Commencement'" }) do
      e =EntityAttribute.all
      return e.first.text_value rescue nil
    end
  end

  # TODO Find better method to deal with attribute problem

  class << self
    def instance_method_already_implemented?(method_name)
      return true if method_name =~ /attribute/
      super
    end
  end

#named_scope :technology, :conditions => "attribute = 'Technology'"
#named_scope :commencement, :conditions => "attribute = 'Commencement'"
end
