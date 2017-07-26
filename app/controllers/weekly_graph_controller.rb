# encoding: utf-8

#  Copyright (c) 2006-2017, Puzzle ITC GmbH. This file is part of
#  PuzzleTime and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/puzzletime.


class WeeklyGraphController < ApplicationController

  before_action :authorize
  before_action :set_period

  def show
    @graph = WorktimeGraph.new(@period || Period.past_month, worktime_graph_user)
  end

  private

  def worktime_graph_user
    @worktime_graph_user ||= Employee.find(params[:employee_id])
  end

  def authorize
    authorize!(:show_worktime_graph, worktime_graph_user)
  end

end
