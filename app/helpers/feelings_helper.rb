# Niko-cale plugin for Redmine
# Copyright (C) 2010  Yuki Kita
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
module FeelingsHelper
  def feeling_list option={}
    title = ""
    if (project = option[:project])
      title = project.name
    elsif (user = option[:user])
      title = user.name
    else
      title = l(:label_niko_cale_all_users)
    end
    "#{l(:label_niko_cale_feeling_list)} (#{h(title)})"
  end
  def link_to_feeling_list option={}
    if (project = option[:project])
      link_to(feeling_list(option), {:controller=>:feelings, :action=>:index, :project_id=>project})
    elsif (user = option[:user])
      link_to(feeling_list(option), {:controller=>:feelings, :action=>:index, :user_id=>user})
    else
      link_to(feeling_list(option), {:controller=>:feelings, :action=>:index})
    end
  end
  def good_image title="", onclick=""
    image_tag("good.png", {:plugin=>:redmine_niko_cale, :title=>title, :onclick=>onclick})
  end
  def ordinary_image title="", onclick=""
    image_tag("ordinary.png", {:plugin=>:redmine_niko_cale, :title=>title, :onclick=>onclick})
  end
  def bad_image title="", onclick=""
    image_tag("bad.png", {:plugin=>:redmine_niko_cale, :title=>title, :onclick=>onclick})
  end
  def null_image
    "<br><br><br>"
  end
  def index_for feeling, with_link=false
    h(feeling.at.to_s.gsub(/-/, "/")) + " (" + (with_link ? link_to_user(feeling.user) : h(feeling.user.name)) +")"
  end
  def comment_of feeling
    [index_for(feeling), feeling.comment].map{|e| sanitize(e)}.join("<br>")
  end
  def image_for feeling
    if feeling
      image = feeling.good? ? good_image : (feeling.bad? ? bad_image : (feeling.ordinary? ? ordinary_image: null_image))
      feeling.has_comment? ? with_baloon(image, comment_of(feeling)) : image
    else
      null_image
    end
  end
  def link_to_feeling feeling
    link_to image_for(feeling), :controller => "feelings", :action => "show", :id => feeling
  end
  def with_baloon object, message=""
    '<span onmouseover="showToolTip(event,\'' + message + '\');return false" onmouseout="hideToolTip()">' + object + '</span>'
  end
end
