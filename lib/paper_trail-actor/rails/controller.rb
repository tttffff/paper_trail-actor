module PaperTrailActor
  module Rails
    module Controller
      def user_for_paper_trail
        current_user if defined?(current_user)
      end
    end
  end
end
