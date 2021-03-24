require_relative "questions_database"

class QuestionLike
    attr_accessor :id, :question_id, :user_id

    def self.likers_for_question_id(question_id)
        likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
            fname
            FROM
            users
            JOIN
            question_likes
            ON
            question_likes.user_id = users.id
            JOIN
            questions
            ON
            question_likes.question_id = questions.id
            WHERE
            questions.id = ?

        SQL
    end

    def self.num_likes_for_question_id(question_id)
        QuestionsDatabase.instance.execute(<<-SQL, question_id)

            SELECT
            COUNT(*)
            FROM
            users
            JOIN
            question_likes
            ON
            question_likes.user_id = users.id
            JOIN
            questions
            ON
            question_likes.question_id = questions.id
            WHERE
            questions.id = ?
            GROUP BY
            questions.id

        SQL
    end

    def self.liked_questions_for_user_id(user_id)

        questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)

            SELECT
            title
            FROM
            questions
            JOIN
            question_likes
            ON
            question_likes.question_id = questions.id
            JOIN
            users
            ON
            users.id = question_likes.user_id
            WHERE
            users.id = ?

        SQL
    end

    def self.most_liked_questions(n)
        questions = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                *
            FROM
                questions
            JOIN question_likes ON question_likes.question_id = questions.id
            GROUP BY
                questions.id
            ORDER BY
                COUNT(*) DESC
            LIMIT ?
        SQL
    end

    def initialize(hash)

        @id = hash["id"]
        @question_id = hash["question_id"]
        @user_id = hash["user_id"]

    end






end