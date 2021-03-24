require_relative "questions_database"

class QuestionFollow

    def self.followers_for_question_id(question_id)
        folowers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                users
            JOIN question_follows ON users.id = question_follows.user_id
            WHERE
                question_follows.question_id = ?
        SQL
    end

    def self.followers_for_user_id(user_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                questions
            JOIN question_follows ON questions.id = question_follows.question_id
            WHERE
                question_follows.user_id = ?
        SQL
    end

    def self.most_followed_questions(n)
        questions = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                *
            FROM
                questions
            JOIN question_follows ON questions.id = question_follows.question_id
            GROUP BY
                questions.id
            ORDER BY
                COUNT(*) DESC
            LIMIT
                ?
        SQL
    end

    attr_accessor :id, :question_id, :user_id

   def initialize(hash)

        @id = hash["id"]
        @question_id = hash["question_id"]
        @user_id = ["user_id"]

   end


   

end