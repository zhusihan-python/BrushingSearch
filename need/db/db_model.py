import os
import sqlite3


proj_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


class DBModels(object):
    def __init__(self):
        self.conn = sqlite3.connect(os.path.join(proj_root, "local.db"))
        self.cur = self.conn.cursor()

    def search_platform(self):
        sql = """SELECT name, id FROM platforms WHERE deleted=0 ORDER BY id ASC"""
        self.cur.execute(sql)
        res = self.cur.fetchall()
        if res:
            return res
        return []


db_model = DBModels()


if __name__ == "__main__":
    platfrom = db_model.search_platform()
    print("platfrom", platfrom)
