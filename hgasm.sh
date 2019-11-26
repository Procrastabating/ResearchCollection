#download main page
wget http://hentaigasm.com/?orderby=title
#get the maximum page number, then generate a txt file with all pages
pages=$(grep -hEo page/[0-9][0-9] *index* | cut -c 6-)
echo $pages
for i in $( seq 1 $pages )
do
      echo "http://hentaigasm.com/page/$i/" >> download.txt
done
rm index.html
#download all pages
wget -i download.txt
clear

#find all episode links
grep -E -o ".{0,150}subbed.{0,1}" *index* | rev | sed 's/".*//' | rev | sort -u > episodes.txt
rm *index* download.txt

#download all episodes and rename them to the same name as the hentai video
for url in $(cat episodes.txt); do wget $url -O $(echo $url | sed "s/\//_/g") ; done

#find the tags and generate a text file with the same name as the hentai
for file in $(ls -Art | grep http) ; do
	grep -Eo ".{0,1}rel="'"tag"'".{0,40}" "$file" | sed 's/<.*//' | rev | sed 's/>.*//' | rev > "$file".txt
done

#make folders episodes for the episode html files, make tags folder for tags text files
mkdir -p episodes
mkdir -p tags
for file in $(ls -Art | grep http) ; do
	smallFile=$(echo "$file" | cut -c34-)
	mv "$file" episodes/"$smallFile"
	mv episodes/*.txt tags
done
rm episodes.txt

#find the direct video link and create episodedl.txt
grep -Eonr ".{0,0}http://217.182.172.142/.{0,98}" episodes/*  | sed 's/".*//' | rev | sed 's/:.*//' | rev | cut -c3- | sort -u > episodedl.txt
clear

#download all videos to videos folder from episodedl.txt 
wget2 --max-threads=4 --no-clobber --progress=bar -P videos -i episodedl.txt
