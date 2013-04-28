class PatientEncounter < ActiveRecord::Base
  # associations
  has_many :participations
  has_one  :location

  #data validation
  validates_associated :participations
  validates_associated :location
  validates :code, :mood_code, :status_code, :acuity_level_code, :presence => true, :on => :save
  validates :id, :uniqueness => true
  validates :mood_code, :length => { :is => 3 }
  validates :acuity_level_code, :numericality => { :only_integer => true }

  # scopes
  default_scope order('id ASC')
  scope :completed,   lambda { |x = nil| where('status_code = "completed"').
                                       order('effective_time DESC').
                                       limit(x)}
  scope :new_events,  lambda { |x = nil| where('mood_code = "EVN" AND status_code = "new"')
                                       order('effective_time DESC').
                                       limit(x)}

  # methods
  def add_participation(participation, signature_code)
    # add a participation to this encounter only if it doesn't already exist
    unless participations.where(:encounter_id => participation.encounter_id).present?
      participations.create(
        :signature_code => signature_code
        )
    else
      false
    end
  end

end
