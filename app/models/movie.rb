class Movie < ActiveRecord::Base
  mount_uploader :poster_image_url, ImageUploader

  has_many :reviews
  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :poster_image_url,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  def review_average
    return 0 if reviews.size == 0
    reviews.sum(:rating_out_of_ten) / reviews.size
      
  end

  scope :director, ->(director){ where("director like?", "%#{director}")}
  scope :title, -> (title){where("title like ?", "%#{title}%")}
  scope :minutes_under90, -> {where("runtime_in_minutes < 90")}
  scope :between90and120, -> {where("runtime_in_minutes > 89 AND runtime_in_minutes < 121")}
  scope :over120, -> {where("runtime_in_minutes > 120")}

  # scope :director, ->


  def self.search(query)
    index = Movie.all
    
    index.title(query[:title]).director(query[:director])

    if query[:runtime_in_minutes]

      case query[:runtime_in_minutes]
      when ''
        index = index
      when '< 90'
        index.minutes_under90
      when '90 - 120'
        index.between90and120
      when '> 120'
        index.over120
      end

    end

  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end


end
