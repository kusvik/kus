from aiohttp import web, ClientSession
import asyncio
import json
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy.orm import declarative_base
from sqlalchemy import exc
from sqlalchemy import select
import copy
import uuid


Base = declarative_base()


engine = create_engine("sqlite:///sqlite_python.db", echo=True, future=True)


class Versions(Base):
    __tablename__ = "Versions"
    id = Column(String(36), primary_key=True)
    type = Column(String(8))
    name = Column(String)
    price = Column(Integer)
    date = Column(String, primary_key=True)
    mother = Column(String(36))
    amount = Column(Integer)
    def __repr__(self):
        return f"Version(id={self.id!r}, name={self.name!r}, price={self.price!r}, type={self.type!r}, mother={self.mother!r}, amount={self.amount!r}, date={self.date!r})"
    def __str__(self):
        return f"Version(id={self.id!r}, name={self.name!r}, price={self.price!r}, type={self.type!r}, mother={self.mother!r}, amount={self.amount!r}, date={self.date!r})"


class Units(Base):
    __tablename__ = "Units"
    id = Column(String(36), primary_key=True)
    type = Column(String(8))
    name = Column(String)
    price = Column(Integer)
    date = Column(String)
    mother = Column(String(36))
    amount = Column(Integer)
    def __repr__(self):
        return f"Unit(id={self.id!r}, name={self.name!r}, price={self.price!r}, type={self.type!r}, mother={self.mother!r}, amount={self.amount!r}, date={self.date!r})"
    def __str__(self):
        return f"Unit(id={self.id!r}, name={self.name!r}, price={self.price!r}, type={self.type!r}, mother={self.mother!r}, amount={self.amount!r}, date={self.date!r})"


async def gets(req):
    name = await req.json()
    return web.Response(text=str(name))

def is_numstr(item):
    for i in item:
        if 57 < ord(i) < 97 or ord(i) > 122 or ord(i) < 48:
            return False
    return True

def valid_id(id):
    if type(id) != type('str'):
        return False
    try:
        uuid.UUID(id)
    except:
        return False
    return True


def valid_item(item, mothers):
    if type(item) != type({'1': '2'}):
        print('\n\nitem is not a dict\n\n')
        return False
    if not ("type" in item and 'name' in item and 'id' in item):
        print('\n\nrequired arg is missing\n\n')
        return False

    if 'price' not in item:
        item['price'] = None
    if 'parentId' not in item:
        item['parentId'] = None
    if item['parentId'] == item['id']:
        print('\n\nI AM MOOOOOM\n\n')
        return False
    if item['type'] == 'CATEGORY':
        if item['price']:
            print('\n\ncategory price exist', item['price'], '\n\n')
            return False
    elif item['type'] != 'OFFER':
        print(f"\n\ntype {item['type']} is not valid\n\n")
        return False
    else:
        if type(item['price']) != type(10):
            print("\n\noffer's price is not int\n\n")
            return False
        elif item['price'] < 0:
            print('price is', item['price'])  # проверяем валидность цены и типа юнита
            return False
    if type(item['name']) != type('str'):
        print(f"\n\nname {item['name']} is not valid\n\n")
        return False  # проверяем валидность имени
    if not valid_id(item['id']):
        print(f"\n\nid {item['id']} is not valid\n\n")
        return False  # проверяем валидность ид
    if item['parentId'] and not valid_id(item['parentId']):
        print(f"\n\nmother's id {item['parentId']} is not valid\n\n")
        return False  # проверяем валидность ид матери
    elif item['parentId']:
        if item['parentId'] not in mothers:
            session = Session(engine)
            mother = session.get(Units, item['parentId'])
            print('\n\n', mother, '\n\n')
            if not mother:
                print(f"\n\nmother {item['parentId']} not exists\n\n")
                return False
            if mother.type != 'CATEGORY':
                print('\n\nmother is not a category\n\n')
                return False
    return len(item) <= 5


def validator_post(req):
    if len(req) != 2:
        print('\n\nlen =', len(req), '\n\n')
        return False
    if 'updateDate' not in req:
        print('\n\ndate is not in req\n\n')
        return False
    if 'items' not in req:
        print('\n\nitems are not in req\n\n')
        return False
    if type(req['items']) != type([1, 2]):
        print('\n\nitems are not a list\n\n')
        return False
    try:
        req['updateDate'] = datetime.fromisoformat(req['updateDate'].replace('Z', '+00:00'))
    except:
        print('\n\ndate', req['updateDate'], 'is not valid\n\n')
        return False
    mothers = []
    for i in req['items']:
        if not valid_item(i, mothers):
            print('\n\n', i, '\nis not valid item\n\n')
            return False
        if i['type']=='CATEGORY':
            mothers.append(i['id'])
        print('\n\n', mothers, '\n\n')
    return True


def ver_from_unit(unit):
    return Versions(id=unit.id, type=unit.type, name=unit.name, price=unit.price, date=unit.date, mother=unit.mother, amount=unit.amount)


def upd_time(unit, time, session):
    while unit.mother:
        id = unit.mother
        unit = session.get(Units, id)
        unit.date = time
        print('time updated')


def upd_amount(unit, amount, session):
    if amount != 0:
        while unit.mother:
            id = unit.mother
            unit = session.get(Units, id)
            unit.amount += amount
            print('amount updated')


def upd_price(unit, price, session):
    if price != 0:
        while unit.mother:
            id = unit.mother
            unit = session.get(Units, id)
            unit.price += price
            print('price updated')


def add_versions(units, session):
    for i in units:
        i = session.get(Units, i)
        key = (i.id, i.date)
        if not session.get(Versions, key):
            session.add(ver_from_unit(i))
        while i.mother:
            id = i.mother
            unit = session.get(Units, id)
            key = (unit.id, unit.date)
            if not session.get(Versions, key):
                session.add(ver_from_unit(unit))
            i = unit


def u_to_u(unit1, unit2, session):
    unit1.name = unit2.name
    unit1.price = unit2.price
    unit1.mother = unit2.mother
    unit1.date = unit2.date


async def post_units(req):
    plan = await req.json()
    if validator_post(plan):
        print('\n\n', plan, 'is ok\n\n')
        date = plan["updateDate"]
        ids = []
        with Session(engine) as session:
            for i in plan['items']:
                ids.append(i['id'])
                if i['type'] == 'OFFER':
                    am = 1
                else:
                    am = 0
                price = i['price']
                if price == None:
                    price = 0
                unit = Units(id=i["id"], type=i['type'], name=i["name"], price=price, date=date, mother=i['parentId'], amount=am)
                print(Units,'\n', unit.id)
                upd = session.get(Units, unit.id)
                upd_time(unit, date, session)
                if not upd:
                    session.add(unit)
                    if unit.type == 'OFFER':
                        upd_price(unit, unit.price, session)
                        upd_amount(unit, 1, session)
                    print('\n\nnew Unit added\n\n')

                else:
                    type1, type2 = upd.type, unit.type
                    upd_time(upd, date, session)
                    p = copy.deepcopy(upd).mother
                    if p:
                        ids.append(p)
                    if type1 != type2:
                        print('\n\ncant change type\n\n')
                        return web.Response(status=400, text='Validation Failed')
                    if type1 == 'CATEGORY':
                        unit.price = upd.price
                        unit.amount = upd.amount
                    mother1 = upd.mother
                    mother2 = unit.mother
                    if mother1 != mother2:
                        upd_price(upd, -upd.price, session)
                        upd_amount(upd, -upd.amount, session)
                        upd_price(unit, unit.price, session)
                        upd_amount(unit, unit.amount, session)
                    else:
                        p_d = upd.price - unit.price  # price difference
                        upd_price(upd, p_d, session)
                    u_to_u(upd, unit, session)
                    print('\n\nsuccessfully updated\n\n')
            add_versions(ids, session)
            session.commit()
            return web.Response(status=200, text='Success')


    else:
        return web.Response(status=400, text='Validation Failed')


async def delete_units(req):
    id = str(req).split('/')[-1]
    if len(id) != 38:
        return web.Response(status=400, text='Validation Failed')
    id = id[:-2]
    if not valid_id(id):
        return web.Response(status=400, text='Validation Failed')
    with Session(engine) as session:
        unit = session.get(Units, id)
        if not unit:
            return web.Response(status=404, text='Item not found')
        upd_price(unit, -unit.price, session)
        upd_amount(unit, -unit.amount, session)
        everybody = [unit]
        while everybody:
            stmt = select(Units).where(Units.mother.in_([i.id for i in everybody]))
            for i in everybody:
                print('\n\ndeleting', i.id, '\n\n')
                session.delete(i)
            everybody = []
            for i in session.scalars(stmt):
                everybody.append(i)
        session.commit()
    return web.Response(status=200, text='Success')


def d_to_d(s):
    return s.replace(' ', 'T')[:-6]+'.000Z'


async def tree(unit, session):
    if unit.amount == 0:
        price = None
    else:
        price = unit.price // unit.amount
    ret = {'type': unit.type, 'name': unit.name, 'id': unit.id, 'parentId': unit.mother, 'price': price, 'date': d_to_d(unit.date)}
    if unit.type == 'OFFER':
        ret['children'] = None
    else:
        stmt = session.scalars(select(Units).where(Units.mother.in_([unit.id])))
        children = []
        for i in stmt:
            child = await tree(i, session)
            children.append(child)
        ret['children'] = children
    return ret


async def get_units(req):
    id = str(req).split('/')[-1]
    if len(id) != 38:
        return web.Response(status=400, text='Validation Failed')
    id = id[:-2]
    if not valid_id(id):
        return web.Response(status=400, text='Validation Failed')
    with Session(engine) as session:
        unit = session.get(Units, id)
        if not unit:
            return web.Response(status=404, text='Item not found')
        ret = await tree(unit, session)
        return web.Response(status=200, body=json.dumps(ret))


def before(date):
    date -= timedelta(days=1)
    return date


async def get_sales(req):
    try:
        req = req.query
        date = req['date']
    except:
        print('\n\ndate req is not valid\n\n')
        return web.Response(status=400, text='Validation Failed')
    try:
        date = datetime.fromisoformat(date.replace('Z', '+00:00'))
    except:
        print('\n\ndate', date, 'is not valid\n\n')
        return web.Response(status=400, text='Validation Failed')
    with Session(engine) as session:
        print(str(before(date)), str(date))
        stmt = select(Units).where(Units.date <= str(date)).where(Units.date >= str(before(date)))
        items = []
        for i in session.scalars(stmt):
            items.append(await tree(i, session))
        return web.Response(status=200, body=json.dumps(items))


async def get_node(req):
    try:
        id = str(req)
        dates = req.query
        date1, date2 = dates['dateStart'], dates['dateEnd']
        id = id.split('/')[-2]
        if not valid_id(id):
            print('\n\n id is not valid\n\n')
            return web.Response(status=400, text='Validation Failed')
        date1 = datetime.fromisoformat(date1.replace('Z', '+00:00'))
        date2 = datetime.fromisoformat(date2.replace('Z', '+00:00'))
    except:
        return web.Response(status=400, text='Validation Failed')
    with Session(engine) as session:
        print(date1, '\n', date2)
        stmt = select(Versions).where(Versions.id == id).where(Versions.date < date2).where(Versions.date >= date1)
        items = []
        for i in session.scalars(stmt):
            items.append(await tree(i, session))
        return web.Response(status=200, body=json.dumps(items))




Base.metadata.create_all(engine)

app = web.Application()
app.router.add_post('/imports', post_units)
app.router.add_delete('/delete/{to}', delete_units)
app.router.add_get('/nodes/{to}', get_units)
app.router.add_get('/sales', get_sales)
app.router.add_get('/node/{to}/statistic', get_node)

web.run_app(app, host="0.0.0.0", port=80)