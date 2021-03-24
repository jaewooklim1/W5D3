require_relative "questions_database"
require_relative "questions"
require_relative "replies"
require_relative "question_follows"
require_relative "question_likes"

class User 

    attr_accessor :fname, :lname

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM
            users
            WHERE
            id = ?
        SQL

        return nil unless user.length > 0
        User.new(user.first)
    end 

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT
            *
            FROM
            users
            WHERE
            fname = ? AND lname = ?
        SQL
        return nil unless user.length > 0
        User.new(user.first)
    end

    def initialize(hash)
        @id = hash["id"]
        @fname = hash["fname"]
        @lname = hash["lname"]
    end

    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
    end

    def followed_questions
        QuestionFollow.followers_for_user_id(@id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(@id)
    end

    def average_karma
        QuestionsDatabase.instance.execute(<<-SQL, @id)
            SELECT
                COUNT(DISTINCT(questions.title)) / CAST(COUNT(question_likes.user_id) AS FLOAT)
            FROM
                questions
            LEFT OUTER JOIN question_likes ON questions.id = question_likes.id
            WHERE
                questions.author_id = ?
        SQL
    end

    def save 

        if self.id == nil
            QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
                INSERT INTO
                    users (fname, lname)
                VALUES
                    (?, ?)
            SQL

            self.id = QuestionsDatabase.instance.last_insert_row_id
        else
            QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
                UPDATE
                    users
                SET
                    fname = ?, lname = ?
                WHERE
                    id = ?

            SQL
        end
            

    end
end