import json
import os

# 读取数据
data_path = 'assets/game/wiki_data.json'
with open(data_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

json_data = json.dumps(data, ensure_ascii=False)

# 使用Flutter原版的颜色系统
html_content = f'''<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>空想森林攻略</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        body {{ 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; 
            background: #FFF9EE; 
            color: #3D2914; 
            min-height: 100vh; 
        }}
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
        .list-item-title {{ font-weight: 600; font-size: 16px; margin-bottom: 8px; line-height: 1.25; }}
        .list-item-subtitle {{ font-size: 14px; color: #6B4A2E; line-height: 1.3; }}
        .detail-page {{ padding-bottom: 80px; }}
        .back-button {{ padding: 12px; cursor: pointer; color: #6B4A2E; }}
        .detail-title {{ font-size: 22px; font-weight: bold; margin-bottom: 12px; }}
        .detail-section {{ margin-bottom: 20px; }}
        .detail-section-title {{ font-weight: 600; margin-bottom: 8px; font-size: 17px; height: 1.2; }}
        .detail-stat {{ display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #FFCC5C; }}
        .magic-canvas {{ background: #FFFCF6; border: 1.5px solid #FFCC5C; border-radius: 12px; margin: 16px 0; }}
        .search-box {{ margin-bottom: 12px; }}
        .search-box input {{ width: 100%; padding: 12px; border: 1.5px solid #FFCC5C; border-radius: 12px; background: #FFF3DC; font-size: 16px; }}
        .filter-section {{ margin-bottom: 16px; }}
        .filter-label {{ font-size: 14px; color: #6B4A2E; margin-bottom: 8px; font-weight: 600; }}
        .list-item-with-icon {{ display: flex; align-items: center; gap: 12px; }}
        .list-item-icon {{ width: 56px; height: 56px; background: #FFCC5C; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 28px; flex-shrink: 0; }}
        .list-item-content {{ flex: 1; }}
        .list-item-caption {{ font-size: 12px; color: #9A7A5C; margin-top: 4px; line-height: 1.3; }}
    </style>
</head>
<body>
    <div class="app-bar">空想森林攻略</div>
    <div class="content">
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
        
        <div id="magic-page" class="page">
            <div class="filter-chips" id="magic-filters"></div>
            <div id="magic-list"></div>
        </div>
        
        <div id="materials-page" class="page">
            <div class="filter-chips" id="materials-filters"></div>
            <div id="materials-list"></div>
        </div>
        
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
        const wikiData = JSON.parse(`{json_data}`);
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
            const filters = ['全部', '水', '火', '风', '土'];
            const container = document.getElementById('magic-filters');
            container.innerHTML = filters.map(f => 
                '<div class="filter-chip ' + (f === currentFilter ? 'active' : '') + '" onclick="filterMagic(\\'' + f + '\\')">' + f + '</div>'
            ).join('');
        }}
        
        function filterMagic(filter) {{
            currentFilter = filter;
            renderMagicFilters();
            renderMagicList();
        }}
        
        function renderMaterialsFilters() {{
            const filters = ['全部', '食材', '炼金材料'];
            const container = document.getElementById('materials-filters');
            container.innerHTML = filters.map(f => 
                '<div class="filter-chip ' + (f === currentFilter ? 'active' : '') + '" onclick="filterMaterials(\\'' + f + '\\')">' + f + '</div>'
            ).join('');
        }}
        
        function filterMaterials(filter) {{
            currentFilter = filter;
            renderMaterialsFilters();
            renderMaterialsList();
        }}
        
        function renderDishesList() {{
            const filtered = wikiData.dishes.filter(d => {{
                if (currentRaceFilter && d.raceName !== currentRaceFilter) return false;
                if (currentCookFilter && d.cookTypeName !== currentCookFilter) return false;
                if (searchQuery && !d.name.toLowerCase().includes(searchQuery)) return false;
                return true;
            }});
            
            const container = document.getElementById('dishes-list');
            container.innerHTML = filtered.map(d => 
                '<div class="list-item" onclick="showDishDetail(\\'' + d.id + '\\')">' +
                '<div class="list-item-title">' + d.name + '</div>' +
                '<div class="list-item-subtitle">' + d.raceName + ' · ' + d.cookTypeName + '</div>' +
                '</div>'
            ).join('');
        }}
        
        function renderMagicList() {{
            const filtered = wikiData.magics.filter(m => 
                currentFilter === '全部' || m.element === currentFilter
            );
            
            const container = document.getElementById('magic-list');
            container.innerHTML = filtered.map(m => 
                '<div class="list-item" onclick="showMagicDetail(\\'' + m.id + '\\')">' +
                '<div class="list-item-title">' + m.name + '</div>' +
                '<div class="list-item-subtitle">' + m.element + ' · ' + m.spell + '</div>' +
                '</div>'
            ).join('');
        }}
        
        function renderMaterialsList() {{
            const filtered = wikiData.materials.filter(m => {{
                if (currentFilter === '全部') return true;
                if (currentFilter === '食材' && m.type === 'food_ingredient') return true;
                if (currentFilter === '炼金材料' && m.type === 'alchemy_material') return true;
                return false;
            }});
            
            const container = document.getElementById('materials-list');
            container.innerHTML = filtered.map(m => 
                '<div class="list-item" onclick="showMaterialDetail(\\'' + m.id + '\\')">' +
                '<div class="list-item-title">' + m.name + '</div>' +
                '<div class="list-item-subtitle">' + m.type + '</div>' +
                '</div>'
            ).join('');
        }}
        
        function showDishDetail(id) {{
            const dish = wikiData.dishes.find(d => d.id === id);
            if (!dish) return;
            
            pageHistory.push(currentPage);
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById('detail-page').classList.add('active');
            
            const content = document.getElementById('detail-content');
            content.innerHTML = `
                <div class="detail-title">${{dish.name}}</div>
                <div class="detail-section">
                    <div class="detail-section-title">基本信息</div>
                    <div class="detail-stat"><span>种族</span><span>${{dish.raceName}}</span></div>
                    <div class="detail-stat"><span>烹饪方式</span><span>${{dish.cookTypeName}}</span></div>
                    <div class="detail-stat"><span>地点</span><span>${{dish.location}}</span></div>
                </div>
                <div class="detail-section">
                    <div class="detail-section-title">食材需求</div>
                    ${{dish.ingredients.map(ing => 
                        '<div class="detail-stat"><span>' + ing.name + '</span><span>x' + ing.quantity + '</span></div>'
                    ).join('')}}
                </div>
                <div class="detail-section">
                    <div class="detail-section-title">成品</div>
                    <div class="detail-stat"><span>${{dish.productName}}</span><span>x${{dish.productQuantity}}</span></div>
                </div>
            `;
        }}
        
        function showMagicDetail(id) {{
            const magic = wikiData.magics.find(m => m.id === id);
            if (!magic) return;
            
            pageHistory.push(currentPage);
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById('detail-page').classList.add('active');
            
            const content = document.getElementById('detail-content');
            content.innerHTML = `
                <div class="detail-title">${{magic.name}}</div>
                <div class="detail-section">
                    <div class="detail-section-title">法阵信息</div>
                    <div class="detail-stat"><span>元素</span><span>${{magic.element}}</span></div>
                    <div class="detail-stat"><span>咒文</span><span>${{magic.spell}}</span></div>
                    <div class="detail-stat"><span>位置</span><span>${{magic.position}}</span></div>
                </div>
                <div class="detail-section">
                    <div class="detail-section-title">效果</div>
                    <div class="detail-stat"><span>${{magic.effect}}</span></div>
                </div>
                <div class="detail-section">
                    <div class="detail-section-title">材料</div>
                    ${{magic.ingredients.map(ing => 
                        '<div class="detail-stat"><span>' + ing.name + '</span><span>x' + ing.quantity + '</span></div>'
                    ).join('')}}
                </div>
            `;
        }}
        
        function showMaterialDetail(id) {{
            const material = wikiData.materials.find(m => m.id === id);
            if (!material) return;
            
            pageHistory.push(currentPage);
            document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
            document.getElementById('detail-page').classList.add('active');
            
            const content = document.getElementById('detail-content');
            content.innerHTML = `
                <div class="detail-title">${{material.name}}</div>
                <div class="detail-section">
                    <div class="detail-section-title">材料信息</div>
                    <div class="detail-stat"><span>类型</span><span>${{material.type}}</span></div>
                    <div class="detail-stat"><span>稀有度</span><span>${{material.rarity}}</span></div>
                    <div class="detail-stat"><span>位置</span><span>${{material.location}}</span></div>
                </div>
                <div class="detail-section">
                    <div class="detail-section-title">用途</div>
                    <div class="detail-stat"><span>${{material.usage}}</span></div>
                </div>
            `;
        }}
        
        // 初始化
        renderPages();
    </script>
</body>
</html>'''

# 写入单文件HTML
output_file = 'fantasy_forest_wiki_single.html'
with open(output_file, 'w', encoding='utf-8') as f:
    f.write(html_content)

print(f"Created single file HTML: {output_file}")
print(f"File size: {os.path.getsize(output_file) / 1024 / 1024:.2f} MB")
print("这个文件可以直接在手机浏览器中打开使用！")