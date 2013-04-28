class PatientEncountersController < ApplicationController
  # filters
  before_filter :require_login,     :except => [:show_locations]

  # Only administrators can add new participation or see all encounters
  before_filter :admin_permission,  :only => [:create_participation, :show_all]

  # Only logged in user can see patient encounters, appointments, recent visits
  before_filter :correct_user,      :only => [:show_all_for_patient, :show_recent_visits, :show_appointments]

  def admin_permission
    deny_access unless Person.roles_by_name(current_user.name).contains? 'Admininistrator'
  end

  def correct_user
    @user = Person.find(params[:user_id])
    deny_access unless current_user?(@user)
  end

  def show_all
    @all_encounters = PatientEncounter
  end

  def show_all_for_patient
    @all_encounters_for_patient = current_user.patient_encounters
  end

  # only display encounter locations (i.e. offices) without patient name
  def show_locations
    @all_encounters = PatientEncounter
    @all_locations = {}
    @all_encounters.each do |x|
      @all_locations[x.location.id] = x.location.name
    end
  end

  # display the last N completed visits requested by user
  def show_recent_visits
    nbr_completed_visits = 5 unless params[:last_appointments].nil?
    @completed_visits = current_user.patient_encounters.completed(nbr_completed_visits)
  end

  # display the next N scheduled visits requested by user
  def show_appointments
    nbr_appointments = 3 unless params[:next_appointments].nil?
    @next_appointments = current_user.patient_encounters.new_events(nbr_appointments)
  end

  # Add user specified participation to patient encounter and attach signature
  # Display participation if it already exists
  def create_participation
    @participation = Participation.find(params[:participation_id])
    @signature_code = params[:signature_code]
    if PatientEncounter.add_participation(@participation, @signature_code)
      redirect_to_root_url
    else
      redirect_to @participation
    end
  end
end
