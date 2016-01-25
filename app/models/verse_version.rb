class VerseVersion < ActiveRecord::Base
  belongs_to :verse
  belongs_to :version
end
