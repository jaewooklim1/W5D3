require_relative "questions_database"

class Reply

    def self.find_by_user_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM
            replies
            WHERE
            user_id = ?
        SQL

        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def self.find_by_question_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)

            SELECT
            *
            FROM
            replies
            WHERE
            question_id = ?
        SQL

        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    attr_accessor :id, :question_id, :user_id, :parent_reply_id, :body
    
    def initialize(hash)

        @id = hash["id"]
        @question_id = hash["question_id"]
        @user_id = hash["user_id"]
        @parent_reply_id = hash["parent_reply_id"]
        @body = hash["body"]        

    end

    def author
        QuestionsDatabase.instance.execute(<<-SQL, @user_id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
    end

    def question
        QuestionsDatabase.instance.execute(<<-SQL, @question_id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
    end

    def parent_reply
        return nil if @parent_reply_id == nil
        QuestionsDatabase.instance.execute(<<-SQL, @parent_reply_id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
    end

    def child_replies
        QuestionsDatabase.instance.execute(<<-SQL, @id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
    end

    def save
        if self.id == nil
            QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.user_id, self.parent_reply_id, self.body)

                INSERT INTO 
                    questions (question_id, user_id, parent_reply_id, body
                VALUES
                    (?, ?, ?, ?)

            SQL

            self.id = QuestionsDatabase.instance.last_insert_row_id
        else
            QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.user_id, self.parent_reply_id, self.body, self.id)
                UPDATE
                    replies
                SET
                    question_id = ?, user_id = ?, parent_reply_id = ?, body = ?
                WHERE
                    id = ?
            SQL
        end
    end

end
