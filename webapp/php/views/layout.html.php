<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>isucon 2</title>
        <link rel="stylesheet" href="/css/ui-lightness/jquery-ui-1.8.24.custom.css" />
        <link rel="stylesheet" href="/css/isucon2.css" />
        <script type="text/javascript" src="/js/jquery-1.8.2.min.js"></script>
        <script type="text/javascript" src="/js/jquery-ui-1.8.24.custom.min.js"></script>
        <script type="text/javascript" src="/js/isucon2.js"></script>
    </head>
    <body>
        <header>
          <a href="/">
            <img src="/images/isucon_title.jpg">
          </a>
        </header>
        <div id="sidebar">
            <?php if (isset($recent_sold)): ?>
                <table>
                    <tr><th colspan="2">最近購入されたチケット</th></tr>
                    <?php foreach ($recent_sold as $item): ?>
                    <tr>
                        <td class="recent_variation"><?= implode(' ', array($item['a_name'], $item['t_name'], $item['v_name'])) ?></td>
                        <td class="recent_seat_id"><?= $item['seat_id'] ?></td>
                    </tr>
                    <?php endforeach; ?>
                </table>
            <?php endif; ?>
        </div>
        <div id="content">
            <?= $content ?>
        </div>
    </body>
</html>
