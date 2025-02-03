# -*- coding: utf-8 -*-
from pathlib import Path
from subprocess import run

DOWNLOAD_DIR = Path(__file__).parent / 'downloads'
DOWNLOAD_DIR.mkdir(exist_ok=True)

YTDL = 'youtube-dl'
YTDL_OPTS = []

downloads = {
    "chapter-01": {
        "Thermodynamics and Phase Equilibria: Introduction": "https://www.youtube.com/watch?v=bEUiUfunnvI",
        "Historical overview": "https://www.youtube.com/watch?v=GKO3MXExI2s",
        "Definitions of Fundamental Concepts": "https://www.youtube.com/watch?v=INwjv9HDCt0",
        "Foundations": "https://www.youtube.com/watch?v=s4UAlDe9-l8",
        "Heat and Work": "https://www.youtube.com/watch?v=4on5epShTrU",
        "James Joule": "https://www.youtube.com/watch?v=id8kgbaYpKM",
        "Definition and Sign Convention for Work": "https://www.youtube.com/watch?v=7nWm_KXV8Mo",
        "First Law of Thermodynamics": "https://www.youtube.com/watch?v=XTx-su6s_sA",
        "Caloric Equation of State": "https://www.youtube.com/watch?v=K90C6w-FP8I",
        "Generalized Form of the First Law": "https://www.youtube.com/watch?v=7h2tcB9fxN0",
        "Internal Energy of an Ideal Gas": "https://www.youtube.com/watch?v=vVySRn5vpHY",
        "Need for Entropy": "https://www.youtube.com/watch?v=tz0mm8zwj9k",
        "Inaccessibility and Empirical Entropy": "https://www.youtube.com/watch?v=AN2ndlPuOiE",
        "Metrical Entropy": "https://www.youtube.com/watch?v=2Kd0eJFO3U4",
        "Adiabatic Processes": "https://www.youtube.com/watch?v=G27IGHhMhQE",
        "Carnot Inequality": "https://www.youtube.com/watch?v=Tso3_y8gKIM",
        "Isothermal Processes": "https://www.youtube.com/watch?v=rN9RDoCThIk",
        "Sadi Carnot": "https://www.youtube.com/watch?v=CJM-hHHG28Q",
        "Second Law of Thermodynamics": "https://www.youtube.com/watch?v=AQ8SMZdoRFY",
        "Equilibrium": "https://www.youtube.com/watch?v=rVK77TYw1hE",
        "3rd Law Measurability of Entropy": "https://www.youtube.com/watch?v=tNekt9tBbwY",
        "Combined Statement": "https://www.youtube.com/watch?v=Ocm_rrOU-Oc",
        "Statistical Definition of Entropy": "https://www.youtube.com/watch?v=vl_UGp6-Tkc",
        "Equations That Are Always True": "https://www.youtube.com/watch?v=THrqc0HixDA",
        "Real World Example: Thermal Cooling": "https://www.youtube.com/watch?v=9bGOoqDSe_o",
        "Worked Problem 1": "https://www.youtube.com/watch?v=EVjKHlC_4Zg",
        "Worked Problem 2": "https://www.youtube.com/watch?v=6RqWIyNoTBs",
    }
}

def make_title(chapter, item, title):
    title = title.replace(':', '').replace(' ', '-')
    title = f"{chapter}_{item:03d}_{title.lower()}"
    return title

for chapter, videos in downloads.items():
    for item, (title, url) in enumerate(videos.items()):
        title = make_title(chapter, item, title)
        print(f"Downloading {title}")
        run([YTDL, *YTDL_OPTS, url, '-o', str(DOWNLOAD_DIR / f'{title}.mp4')])