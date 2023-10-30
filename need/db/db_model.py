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

    def get_hotels(self):
        sql = """SELECT name, addr, contacts, tel, comment, DATE(create_time) FROM hotels 
                    WHERE deleted=0 ORDER BY id ASC"""
        self.cur.execute(sql)
        res = self.cur.fetchall()
        if res:
            return res
        return []

    def insert_hotel(self, name, addr, contacts, tel):
        sql = f"""INSERT INTO hotels (name, addr, contacts, tel) VALUES 
                    ('{name}', '{addr}', '{contacts}', '{tel}')"""
        self.cur.execute(sql)
        self.conn.commit()

    def update_hotel(self, name, addr, contacts, tel, hotel_id):
        sql = f"""UPDATE hotels SET name='{name}', addr='{addr}', contacts'{contacts}', tel='{tel}' 
                    WHERE id={hotel_id}"""
        self.cur.execute(sql)
        self.conn.commit()

    def remove_hotel(self, hotel_id):
        sql = f"""DELETE FROM hotel WHERE id={hotel_id}"""
        self.cur.execute(sql)
        self.conn.commit()


db_model = DBModels()


if __name__ == "__main__":
    HOTELS = db_model.get_hotels()
    print("HOTELS", HOTELS)
