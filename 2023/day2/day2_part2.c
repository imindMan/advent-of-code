// Idea: parsing every single characters and then return the result

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 

int readData(char *content) {
    int i = 5;

    char num_id[3];
    char blue[3];char green[3];char red[3];
    char max_blue[3]; char max_green[3]; char max_red[3];
    char num_temp[3];
    strcpy(blue, "0");
    strcpy(green, "0"); 
    strcpy(red, "0");
    strcpy(max_blue, "0");
    strcpy(max_green, "0");
    strcpy(max_red, "0");
    while (i < strlen(content)) {
        if (i >= 5 && i <= 7) {
            num_id[i - 5] = content[i];
            i++;
        }
        else {
            strcpy(num_temp, "0");
            // start to parse the number of blue, green, and red cubes
            int cursor = 0;
            while (isspace(content[i]) == 0) {
                num_temp[cursor] = content[i];
                i++;
                cursor++;
            }
            i++;
            if (content[i] == 'g') {
                    int first_num = atoi(green);
                    int second_num = atoi(num_temp);
                    int res = first_num + second_num;
                    char buf_res[3];
                    sprintf(buf_res, "%d", res);
                    strcpy(green, buf_res);
                    i += 5;
            }
            else if (content[i] == 'r') {

                    int first_num = atoi(red);
                    int second_num = atoi(num_temp);
                    int res = first_num + second_num;
                    char buf_res[3];
                    sprintf(buf_res, "%d", res);
                    strcpy(red, buf_res);

                    i += 3;
            }
            else if (content[i] == 'b') {

                    int first_num = atoi(blue);
                    int second_num = atoi(num_temp);
                    int res = first_num + second_num;
                    char buf_res[3];
                    sprintf(buf_res, "%d", res);
                    strcpy(blue, buf_res);
                    i += 4;
            }
        }
        if (content[i] == ',') {
            i++;
            continue;
        }
        else if (content[i] == ';' || i >= strlen(content))
        {

            if (atoi(max_red) < atoi(red)) {
                strcpy(max_red, red);
            }
            
            if (atoi(max_green) < atoi(green)) {
                strcpy(max_green, green);
            }
            
            if (atoi(max_blue) < atoi(blue)) {
                strcpy(max_blue, blue);
            }
            strcpy(red, "0");
            strcpy(green, "0");
            strcpy(blue, "0");
            i++;
        }
    }
    return atoi(max_red) * atoi(max_blue) * atoi(max_green);
}

int main()
{
    char *content;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    FILE *input = fopen("day2.txt", "r");
    int total_id = 0;
    while ((read = getline(&line, &len, input)) != -1) { 
        total_id += readData(line);
    }
    printf("%d\n", total_id);
    return 0;

}


