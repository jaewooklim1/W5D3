require_relative "questions_database"
require_relative "replies"
require_relative "question_follows"
require_relative "question_likes"

class Question

    attr_accessor :title, :body, :author_id, :id

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM
            questions
            WHERE
            id = ?
        SQL

        return nil unless question.length > 0
        Question.new(question.first)
    end

    def self.find_by_author_id(author_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
            *
            FROM
            questions
            WHERE
            author_id = ?
        SQL
        
        return nil unless question.length > 0
        Question.new(question.first)
    end
    
    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)       
    end

    def self.most_liked(n)
        QuestionLike.most_liked_questions(n)
    end

    def initialize(hash)
        @id = hash["id"]
        @title = hash["title"]
        @body = hash["body"]
        @author_id = hash["author_id"]
    end

    def author
        author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL

        return nil unless author.length > 0
        User.new(author.first)
    end

    def replies
        Reply.find_by_question_id(@id)
    end

    def followers
        QuestionFollow.followers_for_question_id(@id)
    end
    
    def likers
        QuestionLike.likers_for_question_id(@id)
    end

    def num_likes
        QuestionLike.num_likes_for_question_id(@id)
    end

    def save
        if self.id == nil
            QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author_id )

                INSERT INTO 
                    questions (title, body, author_id)
                VALUES
                    (?, ?, ?)

            SQL
            self.id = QuestionsDatabase.instance.last_insert_row_id

        else
            QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author_id, self.id)
                UPDATE
                    replies
                SET
                    title = ?, body = ?, author_id = ?
                WHERE
                    id = ?
             SQL

        end


        
    end
end

