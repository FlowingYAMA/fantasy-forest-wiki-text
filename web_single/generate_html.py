import json

# 读取数据
with open('d:/MyAPP/fantasy_forest_wiki_text/assets/game/wiki_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

json_str = json.dumps(data, ensure_ascii=False)

# HTML模板
html_template = f'''<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>空想森林攻略Demo</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background: #FFF9EE; color: #3D2914; min-height: 100vh; }}
        .app-bar {{ background: #FFEEAD; border-bottom: 2px solid #FFCC5C; padding: 16px; text-align: center; font-size: 18px; font-weight: 600; }}
        .content {{ padding: 16px; max-width: 600px; margin: 0 auto; padding-bottom: 80px; }}
        .nav-bar {{ position: fixed; bottom: 0; left: 0; right: 0; background: #FFEEAD; border-top: 1px solid #FFCC5C; display: flex; justify-content: space-around; padding: 8px 0; max-width: 600px; margin: 0 auto; }}
        .nav-item {{ text-align: center; padding: 8px 16px; cursor: pointer; color: #6B4A2E; font-size: 14px; }}
        .nav-item.active {{ color: #3D2914; font-weight: 600; }}
        .nav-item-icon {{ font-size: 24px; margin-bottom: 4px; }}
        .page {{ display: none; }}
        .page.active {{ display: block; }}
        .filter-chips {{ display: flex; gap: 8px; overflow-x: auto; padding: 8px 0; margin-bottom: 16px; }}
        .filter-chip {{ padding: 8px 16px; border-radius: 20px; border: 1px solid #FFCC5C; background: #FFF3DC; white-space: nowrap; cursor: pointer; font-size: 14px; }}
        .filter-chip.active {{ background: #FFCC5C; }}
        .list-item {{ background: #FFEEAD; border: 1.5px solid #FFCC5C; border-radius: 12px; padding: 12px; margin-bottom: 12px; cursor: pointer; }}
        .list-item-title {{ font-weight: 600; font-size: 16px; margin-bottom: 8px; }}
        .list-item-subtitle {{ font-size: 14px; color: #6B4A2E; }}
        .detail-page {{ padding-bottom: 80px; }}
        .back-button {{ padding: 12px; cursor: pointer; color: #6B4A2E; }}
        .detail-title {{ font-size: 22px; font-weight: bold; margin-bottom: 12px; }}
        .detail-section {{ margin-bottom: 20px; }}
        .detail-section-title {{ font-weight: 600; margin-bottom: 8px; }}
        .detail-stat {{ display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #FFCC5C; }}
        .magic-canvas {{ background: #FFFCF6; border: 1.5px solid #FFCC5C; border-radius: 12px; margin: 16px 0; }}
        .loading {{ text-align: center; padding: 40px; color: #6B4A2E; }}
        .search-box {{ margin-bottom: 12px; }}
        .search-box input {{ width: 100%; padding: 12px; border: 1.5px solid #FFCC5C; border-radius: 12px; background: #FFF3DC; font-size: 16px; }}
        .filter-section {{ margin-bottom: 16px; }}
        .filter-label {{ font-size: 14px; color: #6B4A2E; margin-bottom: 8px; font-weight: 600; }}
        .list-item-with-icon {{ display: flex; align-items: center; gap: 12px; }}
        .list-item-icon {{ width: 56px; height: 56px; background: #FFCC5C; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 28px; flex-shrink: 0; }}
        .list-item-content {{ flex: 1; }}
        .list-item-caption {{ font-size: 12px; color: #6B4A2E; margin-top: 4px; }}
    </style>
</head>
<body>
    <div class="app-bar">空想森林攻略Demo</div>
    <div class="content">
        <!-- 食谱页面 -->
        <div id="dishes-page" class="page">
            <div class="search-box">
                <input type="text" id="dish-search" placeholder="按菜名搜索…" oninput="searchDishes(this.value)">
            </div>
            <div class="filter-section">
                <div class="filter-label">种族</div>
                <div class="filter-chips" id="dishes-race-filters"></div>
            </div>
            <div class="filter-section">
                <div class="filter-label">烹饪方式</div>
                <div class="filter-chips" id="dishes-cook-filters"></div>
            </div>
            <div id="dishes-list"></div>
        </div>
        
        <!-- 法阵页面 -->
        <div id="magic-page" class="page">
            <div class="filter-chips" id="magic-filters"></div>
            <div id="magic-list"></div>
        </div>
        
        <!-- 材料页面 -->
        <div id="materials-page" class="page">
            <div class="filter-chips" id="materials-filters"></div>
            <div id="materials-list"></div>
        </div>
        
        <!-- 详情页面 -->
        <div id="detail-page" class="page detail-page">
            <div class="back-button" onclick="goBack()">← 返回</div>
            <div id="detail-content"></div>
        </div>
    </div>
    <div class="nav-bar">
        <div class="nav-item" onclick="showPage('dishes')">
            <div class="nav-item-icon">🍽️</div>
            <div>食谱</div>
        </div>
        <div class="nav-item active" onclick="showPage('magic')">
            <div class="nav-item-icon">✨</div>
            <div>法阵</div>
        </div>
        <div class="nav-item" onclick="showPage('materials')">
            <div class="nav-item-icon">📦</div>
            <div>材料</div>
        </div>
    </div>
    <script>
        const wikiData = JSON.parse(`{json_str}`);
        let currentPage = 'magic';
        let currentFilter = '全部';
        let currentRaceFilter = null;
        let currentCookFilter = null;
        let searchQuery = '';
        let pageHistory = [];
        
        function renderPages() {{
            renderDishesRaceFilters();
            renderDishesCookFilters();
            renderMagicFilters();
            renderMaterialsFilters();
            renderDishesList();
            renderMagicList();
            renderMaterialsList();
        }}
        
        function searchDishes(query) {{
            searchQuery = query.toLowerCase();
            renderDishesList();
        }}
        
        function showPage(page) {{
            currentPage = page;
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById(page + '-page').classList.add('active');
            document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
            event.currentTarget.classList.add('active');
            currentFilter = '全部';
            currentRaceFilter = null;
            currentCookFilter = null;
            searchQuery = '';
            document.getElementById('dish-search').value = '';
            renderPages();
        }}
        
        function goBack() {{
            if (pageHistory.length > 0) {{
                const prevPage = pageHistory.pop();
                document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
                document.getElementById(prevPage + '-page').classList.add('active');
            }}
        }}
        
        function renderDishesRaceFilters() {{
            const races = ['全部', ...new Set(wikiData.dishes.map(d => d.raceName))];
            const container = document.getElementById('dishes-race-filters');
            container.innerHTML = races.map(r => 
                '<div class="filter-chip ' + (r === currentRaceFilter || (r === '全部' && currentRaceFilter === null) ? 'active' : '') + '" onclick="filterDishesRace(\\'' + r + '\\')">' + r + '</div>'
            ).join('');
        }}
        
        function renderDishesCookFilters() {{
            const cookTypes = ['全部', ...new Set(wikiData.dishes.map(d => d.cookTypeName))];
            const container = document.getElementById('dishes-cook-filters');
            container.innerHTML = cookTypes.map(c => 
                '<div class="filter-chip ' + (c === currentCookFilter || (c === '全部' && currentCookFilter === null) ? 'active' : '') + '" onclick="filterDishesCook(\\'' + c + '\\')">' + c + '</div>'
            ).join('');
        }}
        
        function filterDishesRace(race) {{
            currentRaceFilter = race === '全部' ? null : race;
            renderDishesRaceFilters();
            renderDishesList();
        }}
        
        function filterDishesCook(cook) {{
            currentCookFilter = cook === '全部' ? null : cook;
            renderDishesCookFilters();
            renderDishesList();
        }}
        
        function renderMagicFilters() {{
            const filters = ['全部', '土', '水', '火', '风'];
            const container = document.getElementById('magic-filters');
            container.innerHTML = filters.map(f => 
                '<div class="filter-chip ' + (f === currentFilter ? 'active' : '') + '" onclick="filterMagic(\\'' + f + '\\')">' + f + '</div>'
            ).join('');
        }}
        
        function renderMaterialsFilters() {{
            const filters = ['全部', '食材', '炼金'];
            const container = document.getElementById('materials-filters');
            container.innerHTML = filters.map(f => 
                '<div class="filter-chip ' + (f === currentFilter ? 'active' : '') + '" onclick="filterMaterials(\\'' + f + '\\')">' + f + '</div>'
            ).join('');
        }}
        
        function filterDishes(filter) {{
            currentFilter = filter;
            renderDishesFilters();
            renderDishesList();
        }}
        
        function filterMagic(filter) {{
            currentFilter = filter;
            renderMagicFilters();
            renderMagicList();
        }}
        
        function filterMaterials(filter) {{
            currentFilter = filter;
            renderMaterialsFilters();
            renderMaterialsList();
        }}
        
        function renderDishesList() {{
            const container = document.getElementById('dishes-list');
            let dishes = wikiData.dishes;
            if (currentRaceFilter) {{
                dishes = dishes.filter(d => d.raceName === currentRaceFilter);
            }}
            if (currentCookFilter) {{
                dishes = dishes.filter(d => d.cookTypeName === currentCookFilter);
            }}
            if (searchQuery) {{
                dishes = dishes.filter(d => d.name.toLowerCase().includes(searchQuery));
            }}
            container.innerHTML = dishes.map((d, i) => 
                '<div class="list-item list-item-with-icon" onclick="showDishDetail(' + wikiData.dishes.indexOf(d) + ')"><div class="list-item-icon">🍽️</div><div class="list-item-content"><div class="list-item-title">' + d.name + '</div><div class="list-item-subtitle">' + d.raceName + ' · ' + d.cookTypeName + '</div></div></div>'
            ).join('');
        }}
        
        function renderMagicList() {{
            const container = document.getElementById('magic-list');
            const circles = wikiData.magicCircles.filter(m => currentFilter === '全部' || m.element === currentFilter);
            container.innerHTML = circles.map((m, i) => 
                '<div class="list-item list-item-with-icon" onclick="showMagicDetail(' + wikiData.magicCircles.indexOf(m) + ')"><div class="list-item-icon">✨</div><div class="list-item-content"><div class="list-item-title">' + m.element + ' · ' + m.level + '阶 · ' + m.name + '</div><div class="list-item-subtitle">攻击力 ' + m.stats['攻击力'] + ' · 消耗魔力 ' + m.stats['消耗魔力'] + '</div><div class="list-item-caption">暴击率 ' + m.stats['暴击率'] + '% · 暴击伤害 ' + m.stats['暴击伤害'] + '%</div></div></div>'
            ).join('');
        }}
        
        function renderMaterialsList() {{
            const container = document.getElementById('materials-list');
            let items = [];
            if (currentFilter === '全部' || currentFilter === '食材') {{
                items = items.concat(wikiData.ingredientsFood.map((i, idx) => ({{...i, type: '食材', origIdx: idx}})));
            }}
            if (currentFilter === '全部' || currentFilter === '炼金') {{
                items = items.concat(wikiData.ingredientsAlchemy.map((i, idx) => ({{...i, type: '炼金', origIdx: idx}})));
            }}
            container.innerHTML = items.map(i => 
                '<div class="list-item list-item-with-icon" onclick="showMaterialDetail(\\'' + i.type + '\\', ' + i.origIdx + ')"><div class="list-item-icon">' + (i.type === '食材' ? '🥦' : '⚗️') + '</div><div class="list-item-content"><div class="list-item-title">' + i.name + '</div><div class="list-item-subtitle">' + i.type + ' · 稀有度 ' + i.rarity + '</div></div></div>'
            ).join('');
        }}
        
        function showDishDetail(index) {{
            const dish = wikiData.dishes[index];
            pageHistory.push(currentPage);
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById('detail-page').classList.add('active');
            
            const content = document.getElementById('detail-content');
            content.innerHTML = '<div class="detail-title">' + dish.name + '</div><div class="detail-section"><div class="detail-section-title">基本信息</div><div class="detail-stat"><span>种族</span><span>' + dish.raceName + '</span></div><div class="detail-stat"><span>烹饪方式</span><span>' + dish.cookTypeName + '</span></div></div><div class="detail-section"><div class="detail-section-title">主要食材</div>' + dish.mainFoodItems.map(i => '<div class="detail-stat"><span>' + i.name + '</span></div>').join('') + '</div>';
        }}
        
        function showMagicDetail(index) {{
            const circle = wikiData.magicCircles[index];
            pageHistory.push(currentPage);
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById('detail-page').classList.add('active');
            
            const content = document.getElementById('detail-content');
            content.innerHTML = '<div class="detail-title">' + circle.name + '</div><div class="detail-section"><div class="detail-section-title">基本信息</div><div class="detail-stat"><span>元素</span><span>' + circle.element + '</span></div><div class="detail-stat"><span>阶数</span><span>' + circle.level + '</span></div></div><div class="detail-section"><div class="detail-section-title">结构图</div><canvas id="magic-canvas" class="magic-canvas" width="300" height="300"></canvas></div><div class="detail-section"><div class="detail-section-title">属性</div><div class="detail-stat"><span>攻击力</span><span>' + circle.stats['攻击力'] + '</span></div><div class="detail-stat"><span>暴击率</span><span>' + circle.stats['暴击率'] + '%</span></div><div class="detail-stat"><span>暴击伤害</span><span>' + circle.stats['暴击伤害'] + '%</span></div><div class="detail-stat"><span>消耗魔力</span><span>' + circle.stats['消耗魔力'] + '</span></div><div class="detail-stat"><span>消耗魔法石</span><span>' + circle.stats['消耗魔法石'] + '</span></div></div>';
            
            setTimeout(() => drawMagicCircle(circle), 100);
        }}
        
        function drawMagicCircle(circle) {{
            const canvas = document.getElementById('magic-canvas');
            if (!canvas || !circle.diagram) return;
            
            const ctx = canvas.getContext('2d');
            const diagram = circle.diagram;
            const elementKey = circle.elementKey;
            
            const colors = {{
                water: '#00E5FF',
                fire: '#FF5252',
                wind: '#69F0AE',
                soil: '#FFD740'
            }};
            
            const neonColor = colors[elementKey] || '#00E5FF';
            
            const width = canvas.width;
            const height = canvas.height;
            const centerX = width / 2;
            const centerY = height / 2;
            const radius = Math.min(width, height) * 0.38;
            
            ctx.clearRect(0, 0, width, height);
            
            const points = diagram.points.map(p => ({{
                x: centerX + p[0] * radius,
                y: centerY - p[1] * radius
            }}));
            
            ctx.fillStyle = '#FFFFFF';
            points.forEach(p => {{
                ctx.beginPath();
                ctx.arc(p.x, p.y, 5.5, 0, Math.PI * 2);
                ctx.fill();
            }});
            
            ctx.strokeStyle = neonColor;
            ctx.lineWidth = 3.2;
            ctx.lineCap = 'round';
            
            diagram.graphs.forEach(graph => {{
                graph.lines.forEach(line => {{
                    const a = points[line[0]];
                    const b = points[line[1]];
                    if (a && b) {{
                        ctx.beginPath();
                        ctx.moveTo(a.x, a.y);
                        ctx.lineTo(b.x, b.y);
                        ctx.stroke();
                    }}
                }});
            }});
        }}
        
        function showMaterialDetail(type, index) {{
            const items = type === '食材' ? wikiData.ingredientsFood : wikiData.ingredientsAlchemy;
            const item = items[index];
            pageHistory.push(currentPage);
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById('detail-page').classList.add('active');
            
            const content = document.getElementById('detail-content');
            content.innerHTML = '<div class="detail-title">' + item.name + '</div><div class="detail-section"><div class="detail-section-title">基本信息</div><div class="detail-stat"><span>类型</span><span>' + type + '</span></div><div class="detail-stat"><span>稀有度</span><span>' + item.rarity + '</span></div><div class="detail-stat"><span>重量</span><span>' + item.weight + '</span></div></div><div class="detail-section"><div class="detail-section-title">描述</div><div>' + (item.desc || '暂无描述') + '</div></div>';
        }}
        
        renderPages();
    </script>
</body>
</html>'''

# 写入文件
with open('d:/MyAPP/fantasy_forest_wiki_text/web_single/index.html', 'w', encoding='utf-8') as f:
    f.write(html_template)

print('Single file HTML generated successfully')
